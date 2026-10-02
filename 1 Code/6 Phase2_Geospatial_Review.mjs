// Presentation-only companion, invoked after Stata has validated the GIS inputs.
import fs from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import {FileBlob, SpreadsheetFile} from '@oai/artifact-tool';

const root = process.argv[2];
if (!root) throw new Error('Dropbox project root required');
const data = path.join(root, '3 Data/2 Working/Phase2_Geospatial_Frame');
const target = path.join(root, '4 Deliverables and Presentations/Phase2_Administrative_Village_Census.xlsx');
const stage = path.join(data, 'phase2_review_workbook.staging.xlsx');
const before = await fs.readFile(target);
const digest = b => crypto.createHash('sha256').update(b).digest('hex');
const wb = await SpreadsheetFile.importXlsx(await FileBlob.load(target));
const previews = path.dirname(process.argv[1]);
if (process.argv.includes('--inspect')) {
  console.log((await wb.inspect({kind:'sheet',include:'id,name',maxChars:2500})).ndjson);
  const blob = await wb.render({sheetName:'Overview',range:'A1:G20',scale:1.5,format:'png'});
  await fs.writeFile(path.join(previews,'geo_before.png'),new Uint8Array(await blob.arrayBuffer()));
  process.exit(0);
}
const inputs = JSON.parse(await fs.readFile(path.join(data,'review_workbook_inputs.json'),'utf8'));
const originalSheets = new Map();
for (const n of ['Overview','Villages','Crosswalk','Issues','Sources','Checks','Dictionary','ReadMe']) {
  const s = wb.worksheets.getItem(n);
  originalSheets.set(n,JSON.stringify({values:s.getUsedRange().values,formulas:s.getUsedRange().formulas}));
}
const priorNotes = new Map();
let existingReview;
try { existingReview = wb.worksheets.getItem('GeoReview'); } catch {}
if (existingReview) {
  const rows = existingReview.getUsedRange().values;
  const cols = rows[0];
  for (const r of rows.slice(1)) priorNotes.set(r[cols.indexOf('phase2_lc_uid')],
    [r[cols.indexOf('review_decision')],r[cols.indexOf('review_evidence')]]);
}
for (const r of inputs.GeoReview) {
  const notes = priorNotes.get(r.phase2_lc_uid);
  if (notes) [r.review_decision,r.review_evidence] = notes;
}
for (const [name,records] of Object.entries(inputs)) {
  let sheet;
  try { sheet = wb.worksheets.getItem(name); } catch { sheet = wb.worksheets.add(name); }
  for (const t of sheet.tables.items) t.delete();
  sheet.getUsedRange()?.clear({applyTo:'all'});
  sheet.showGridLines = false;
  const headers = Object.keys(records[0]);
  const rows = [headers,...records.map(r => headers.map(k => {
    const v = r[k] ?? '';
    return typeof v === 'string' && v.startsWith('=') ? "'"+v : v;
  }))];
  const area = sheet.getRangeByIndexes(0,0,rows.length,headers.length);
  area.values = rows;
  area.format = {font:{name:'Arial',size:10,color:'#233243'},rowHeightPx:32,verticalAlignment:'center'};
  const hdr = sheet.getRangeByIndexes(0,0,1,headers.length);
  hdr.format = {fill:'#243B53',font:{name:'Arial',size:10,bold:true,color:'#FFFFFF'},wrapText:true,
                rowHeightPx:58,horizontalAlignment:'center',verticalAlignment:'center'};
  for (let j=0;j<headers.length;j++) {
    const h=headers[j], col=sheet.getRangeByIndexes(1,j,rows.length-1,1);
    const numeric=records.some(r=>typeof r[h]==='number');
    const width=/definition|interpretation_or|sha256|source_url|issue|detail|action|review_evidence|license|reason_/.test(h)?500:
                h==='source_row_id'?370:h==='reference_date'?430:
                /_uid|status|coordinate_basis|source_file|source_location/.test(h)?330:
                /subcounty|parish|village|source_id|file|use_category|vintage/.test(h)?245:name==='GeoCoverage'?200:160;
    sheet.getRangeByIndexes(0,j,rows.length,1).format.columnWidthPx=width;
    col.setNumberFormat(/_utc$/.test(h)?'yyyy-mm-dd hh:mm:ss "UTC"':numeric?(/lon|lat/.test(h)?'0.000000':'0'):'@');
    col.format.horizontalAlignment=numeric?'right':'left';
    col.format.wrapText=/definition|interpretation_or|reference_date|source_row_id|subcounty|parish|village|status|basis|vintage|license|reason_|issue|detail|action|source_url|source_file|source_location|review_evidence/.test(h);
    if (/status|decision/.test(h)) col.conditionalFormats.add('containsText',
      {text:'review',format:{fill:'#FFF2CC',font:{color:'#7F6000'}}});
    if (h==='review_decision'||h==='review_evidence') col.format.fill='#FFF2CC';
  }
  for (let i=1;i<rows.length;i++) {
    const lines=Math.max(1,...rows[i].map(v=>Math.ceil(String(v).length/70)));
    if (lines>1) sheet.getRangeByIndexes(i,0,1,headers.length).format.rowHeightPx=lines*16+14;
  }
  sheet.tables.add(area,true,name+'Data');
  sheet.freezePanes.freezeRows(1);
  if (['GeoReview','GeoProject'].includes(name)) sheet.freezePanes.freezeColumns(4);
}
const coverage=wb.worksheets.getItem('GeoCoverage');
coverage.tabColor='#243B53';
for(let j=1;j<Object.keys(inputs.GeoCoverage[0]).length;j++) {
  coverage.getCell(4,j).formulas=[[`=SUM(${String.fromCharCode(65+j)}2:${String.fromCharCode(65+j)}4)`]];
}
wb.recalculate();
for (const [n,snapshot] of originalSheets) {
  const s=wb.worksheets.getItem(n);
  if (snapshot!==JSON.stringify({values:s.getUsedRange().values,formulas:s.getUsedRange().formulas}))
    throw new Error('Milestone 1 worksheet values/formulas changed: '+n);
}
console.log((await wb.inspect({kind:'match',searchTerm:'#REF!|#DIV/0!|#VALUE!|#NAME\\?|#NUM!|#SPILL!',
                             options:{useRegex:true,maxResults:20},maxChars:1500})).ndjson);
for (const [sheetName,range] of [['GeoCoverage','A1:I5'],['GeoReview','A1:F8'],['GeoProject','A1:F6'],
                                ['GeoSources','A1:D6'],['GeoQA','A1:E6'],['GeoDictionary','A1:C6']]) {
  const blob=await wb.render({sheetName,range,scale:1.5,format:'png'});
  await fs.writeFile(path.join(previews,sheetName+'.png'),new Uint8Array(await blob.arrayBuffer()));
}
await (await SpreadsheetFile.exportXlsx(wb)).save(stage);
if(digest(await fs.readFile(target))!==digest(before)) throw new Error('Workbook changed concurrently; staged export not promoted');
await fs.rename(stage,target);
console.log(JSON.stringify({workbook:target,newSheets:Object.keys(inputs),originalSheetsUnchanged:true}));
