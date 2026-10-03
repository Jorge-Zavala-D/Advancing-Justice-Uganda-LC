// Presentation-only companion, invoked after Stata has validated the GIS inputs.
import fs from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import {FileBlob, SpreadsheetFile} from '@oai/artifact-tool';

const root = process.argv[2];
if (!root) throw new Error('Dropbox project root required');
const reconcile = process.argv.includes('--reconcile');
const neighbors = process.argv.includes('--neighbors');
const coverageMode = process.argv.includes('--coverage');
const verificationMode = process.argv.includes('--verification');
const typed = neighbors || coverageMode || verificationMode;
if ([reconcile,neighbors,coverageMode,verificationMode].filter(Boolean).length>1) throw new Error('Choose exactly one extension mode');
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
const inputs = JSON.parse(await fs.readFile(path.join(data,verificationMode?'verification_workbook_inputs.json':coverageMode?'coverage_workbook_inputs.json':neighbors?'neighbor_workbook_inputs.json':reconcile?'reconciliation_workbook_inputs.json':'review_workbook_inputs.json'),'utf8'));
const reconciliationSheets = ['ReconciledCoverage','IdentityReview','UBOSParents','ReconcileQA'];
const neighborSheets = ['NeighborCoverage','NeighborSensitivity','SharedCandidates','MilestoneAudit'];
const coverageSheets = ['VillageCoverage','CoverageReview','BoundarySources','SourceDiscrepancies'];
const verificationSheets = ['AcquisitionFollowup','VillageFieldReview','NeighborFieldReview','NeighborAdditions','OSMNameReview','FrameDecisions'];
if (reconcile && (Object.keys(inputs).length!==reconciliationSheets.length ||
    reconciliationSheets.some(n=>!Array.isArray(inputs[n]) || !inputs[n].length)))
  throw new Error('Reconciliation input must contain exactly four populated sheets');
const typedSheets = verificationMode?verificationSheets:coverageMode?coverageSheets:neighborSheets;
if (typed && (Object.keys(inputs).length!==typedSheets.length || typedSheets.some(n=>
    !Array.isArray(inputs[n]?.fields) || !inputs[n].fields.length ||
    inputs[n].fields.some(h=>typeof h!=='string' || !h) ||
    new Set(inputs[n].fields).size!==inputs[n].fields.length ||
    !Array.isArray(inputs[n].rows) || (!['SharedCandidates','OSMNameReview'].includes(n) && !inputs[n].rows.length) ||
    inputs[n].rows.some(r=>!r || typeof r!=='object' || Array.isArray(r) ||
      Object.keys(r).some(h=>!inputs[n].fields.includes(h)) ||
      inputs[n].fields.some(h=>!Object.hasOwn(r,h)) ||
      Object.entries(r).some(([h,v])=>h.endsWith('_uid') && v!=null && typeof v!=='string')))))
  throw new Error('Extension input must contain exact fields/rows tables with string identifiers');
const originalSheets = new Map();
const preservedSheets = ['Overview','Villages','Crosswalk','Issues','Sources','Checks','Dictionary','ReadMe',
  ...(reconcile || typed?['GeoCoverage','GeoReview','GeoProject','GeoSources','GeoQA','GeoDictionary']:[]),
  ...(typed?reconciliationSheets:[]), ...((coverageMode || verificationMode)?neighborSheets:[]), ...(verificationMode?coverageSheets:[])];
for (const n of preservedSheets) {
  const s = wb.worksheets.getItem(n);
  originalSheets.set(n,JSON.stringify({values:s.getUsedRange().values,formulas:s.getUsedRange().formulas}));
}
const priorNotes = new Map();
const reviewSheet = coverageMode?'CoverageReview':reconcile?'IdentityReview':'GeoReview';
const reviewKey = coverageMode?'reference_row_id':reconcile?'source_row_id':'phase2_lc_uid';
let existingReview;
try { existingReview = wb.worksheets.getItem(reviewSheet); } catch {}
if (!neighbors && !verificationMode && existingReview) {
  const rows = existingReview.getUsedRange().values;
  const cols = rows[0];
  if ((reconcile || coverageMode) && [reviewKey,'review_decision','review_evidence'].some(c=>!cols.includes(c)))
    throw new Error('Existing IdentityReview is missing its review key or editable columns');
  for (const r of rows.slice(1)) {
    const key=r[cols.indexOf(reviewKey)];
    if ((reconcile || coverageMode) && (!key || priorNotes.has(key))) throw new Error('Review sheet has missing or duplicate row identifier');
    priorNotes.set(key,[r[cols.indexOf('review_decision')],r[cols.indexOf('review_evidence')]]);
  }
}
const reviewIds = new Set();
for (const r of (neighbors || verificationMode)?[]:coverageMode?inputs[reviewSheet].rows:inputs[reviewSheet]) {
  if ((reconcile || coverageMode) && (!r[reviewKey] || reviewIds.has(r[reviewKey])))
    throw new Error('Reconciliation input has missing or duplicate source_row_id');
  reviewIds.add(r[reviewKey]);
  if (reconcile || coverageMode) { r.review_decision ??= ''; r.review_evidence ??= ''; }
  const notes = priorNotes.get(r[reviewKey]);
  if (notes) [r.review_decision,r.review_evidence] = notes;
}
if ((reconcile || coverageMode) && [...priorNotes].some(([key,notes])=>!reviewIds.has(key) && notes.some(v=>v!=='' && v!=null)))
  throw new Error('A prior IdentityReview note has no corresponding source row; refusing to discard it');
const editableReviewFields = new Set(['review_decision','review_evidence','confirmed_ec_lc_uid','current_official_code',
  'confirmed_district','confirmed_subcounty','confirmed_parish','confirmed_village','reference_lon','reference_lat',
  'reference_point_definition','coordinate_method','gps_accuracy_m','verification_date','verifier_role','independent_check_role',
  'confirmed_anchor_ec_uid','confirmed_candidate_ec_uid','local_neighbor_status','neighbor_basis','reciprocal_check',
  'travel_mode','travel_minutes','seasonal_access','shared_anchor_ids','ownership_decision',
  'request_date','response_date','response_source_path','boundary_vintage','reuse_permission','approval_role','approval_date']);
const verificationKeys = {AcquisitionFollowup:'source_id',VillageFieldReview:'review_row_id',NeighborFieldReview:'edge_review_id',
  NeighborAdditions:'addition_row_id',FrameDecisions:'decision_id'};
if (verificationMode) for (const [name,key] of Object.entries(verificationKeys)) {
  let prior; try {prior=wb.worksheets.getItem(name);} catch {continue;}
  const values=prior.getUsedRange().values, headers=values[0], saved=new Map();
  for (const row of values.slice(1)) {
    const id=row[headers.indexOf(key)];
    if (!id || saved.has(id)) throw new Error('Missing/duplicate prior review key: '+name);
    const fields = name==='NeighborAdditions'?headers.filter(h=>!['addition_row_id','record_status','current_boundary_certified','rct_geographic_release'].includes(h)):headers.filter(h=>editableReviewFields.has(h));
    saved.set(id,Object.fromEntries(fields.map(h=>[h,row[headers.indexOf(h)]??''])));
  }
  const ids=new Set(inputs[name].rows.map(r=>r[key]));
  if([...saved].some(([id,r])=>!ids.has(id)&&Object.values(r).some(v=>v!==''&&v!=null))) throw new Error('Review input would be discarded: '+name);
  for(const r of inputs[name].rows) Object.assign(r,saved.get(r[key])??{});
}
for (const [name,input] of Object.entries(inputs)) {
  const records=typed?input.rows:input;
  let sheet;
  try { sheet = wb.worksheets.getItem(name); } catch { sheet = wb.worksheets.add(name); }
  for (const t of sheet.tables.items) t.delete();
  // Range.clear(all) retains column-scoped conditional rules on import.
  // Reset each owned M6 column below before adding its current rules.
  sheet.getUsedRange()?.clear({applyTo:'all'});
  sheet.showGridLines = false;
  const headers = typed?input.fields:Object.keys(records[0]);
  const rows = [headers,...records.map(r => headers.map(k => {
    const v = r[k] ?? '';
    // The exporter auto-parses bare ISO timestamps even with text format.
    // An explicit timezone prefix keeps the exact timestamp as visible text;
    // the JSON/CSV/native source retains the unprefixed ISO-8601 value.
    if (verificationMode && k.endsWith('_utc') && typeof v==='string' && v)
      return 'UTC '+v;
    return typeof v === 'string' && v.startsWith('=') ? "'"+v : v;
  }))];
  const area = sheet.getRangeByIndexes(0,0,rows.length,headers.length);
  area.values = rows;
  area.format = {...(verificationMode?{fill:'#FFFFFF'}:{}),font:{name:'Arial',size:10,color:'#233243'},rowHeightPx:32,verticalAlignment:'center'};
  const hdr = sheet.getRangeByIndexes(0,0,1,headers.length);
  hdr.format = {fill:'#243B53',font:{name:'Arial',size:10,bold:true,color:'#FFFFFF'},wrapText:true,
                rowHeightPx:58,horizontalAlignment:'center',verticalAlignment:'center'};
  const widths=[];
  for (let j=0;j<headers.length;j++) {
    const h=headers[j];
    const numeric=records.some(r=>typeof r[h]==='number') ||
      (verificationMode && ['reference_lon','reference_lat','gps_accuracy_m','travel_minutes'].includes(h));
    const width=/definition|interpretation_or|sha256|source_url|issue|detail|action|review_evidence|license|reason_|all_names|caveat|limitation|scenario_definition|source_basis|anchor_lc_uids|^unit$/.test(h)?500:
                coverageMode && /^(reference_group|source_id)$/.test(h)?370:
                coverageMode && /^(title|layer_name)$/.test(h)?330:
                /source_row_id$|reference_row_id$/.test(h)?370:h==='reference_date'?430:
                /_uid|status|coordinate_basis|source_file|source_location|^check$/.test(h)?330:
                /county|parish|village|source_id|file|use_category|vintage/.test(h)?245:
                typed && h.length>20?280:['GeoCoverage','ReconciledCoverage','VillageCoverage'].includes(name)?200:160;
    sheet.getRangeByIndexes(0,j,rows.length,1).format.columnWidthPx=width;
    widths.push(width);
    if (!records.length) continue;
    const col=sheet.getRangeByIndexes(1,j,rows.length-1,1);
    if (verificationMode) col.conditionalFormats.clear();
    // M6 source timestamps are immutable ISO-8601 strings, not Excel dates.
    col.setNumberFormat(!verificationMode && /_utc$/.test(h)?'yyyy-mm-dd hh:mm:ss "UTC"':numeric?(/lon|lat/.test(h)?'0.000000':typed && /_km$|_km2$|_m$|_m2$|distance|threshold/.test(h)?'0.000':'0'):'@');
    col.format.horizontalAlignment=numeric?'right':'left';
    col.format.wrapText=((coverageMode || verificationMode) && !numeric) || /definition|interpretation_or|reference_date|source_row_id|county|parish|village|status|basis|vintage|license|reason_|issue|detail|action|source_url|source_file|source_location|review_evidence|all_names|caveat|limitation|scenario_definition|anchor_lc_uids|^unit$|^check$/.test(h);
    if (/status|decision/.test(h) && (!verificationMode || h.endsWith('_status') || h==='review_decision'))
      col.conditionalFormats.add('containsText',
        {text:'review',format:{fill:verificationMode && h!=='review_decision'?'#FCE4D6':'#FFF2CC',font:{color:'#7F6000'}}});
    if (h==='review_decision'||h==='review_evidence'||(verificationMode && (editableReviewFields.has(h)||
      name==='NeighborAdditions'&&!['addition_row_id','record_status','current_boundary_certified','rct_geographic_release'].includes(h)))) col.format.fill='#FFF2CC';
    if (verificationMode && ['local_neighbor_status','reciprocal_check'].includes(h)) col.dataValidation={rule:{type:'list',values:['Confirmed','Not confirmed','Unresolved']}};
    if (verificationMode && h==='review_decision') col.dataValidation={rule:{type:'list',values:['Confirm','Reject','Unresolved','Request sent','Response received']}};
    if (verificationMode && h==='neighbor_basis') col.dataValidation={rule:{type:'list',values:['Current boundary adjacency','Locally verified adjacency','Proximity only','Access relationship only','Unresolved']}};
  }
  for (let i=1;i<rows.length;i++) {
    const lines=Math.max(1,...rows[i].map((v,j)=>(coverageMode || verificationMode)?
      String(v).split(/\r?\n/).reduce((n,s)=>n+Math.max(1,Math.ceil(s.length/Math.max(12,Math.floor((widths[j]-16)/6.5)))),0):Math.ceil(String(v).length/70)));
    if (lines>1) sheet.getRangeByIndexes(i,0,1,headers.length).format.rowHeightPx=lines*16+14;
  }
  if (records.length) sheet.tables.add(area,true,name+'Data');
  sheet.freezePanes.freezeRows(1);
  if (['GeoReview','GeoProject','IdentityReview','UBOSParents','NeighborCoverage','NeighborSensitivity','SharedCandidates','CoverageReview',...verificationSheets].includes(name)) sheet.freezePanes.freezeColumns(4);
}
const coverageName=verificationMode?'AcquisitionFollowup':coverageMode?'VillageCoverage':neighbors?'NeighborCoverage':reconcile?'ReconciledCoverage':'GeoCoverage';
const coverage=wb.worksheets.getItem(coverageName);
coverage.tabColor='#243B53';
const coverageRecords=inputs[coverageName];
if (!typed && (!reconcile || coverageRecords.at(-1).district==='TOTAL')) {
  const totalRow=coverageRecords.length;
  for(let j=1;j<Object.keys(coverageRecords[0]).length;j++) {
    if (reconcile && typeof Object.values(coverageRecords[0])[j]!=='number') continue;
    const column=String.fromCharCode(65+j);
    coverage.getCell(totalRow,j).formulas=[[`=SUM(${column}2:${column}${totalRow})`]];
  }
}
wb.recalculate();
for (const [n,snapshot] of originalSheets) {
  const s=wb.worksheets.getItem(n);
  if (snapshot!==JSON.stringify({values:s.getUsedRange().values,formulas:s.getUsedRange().formulas}))
    throw new Error('Preserved worksheet values/formulas changed: '+n);
}
console.log((await wb.inspect({kind:'match',searchTerm:'#REF!|#DIV/0!|#VALUE!|#NAME\\?|#NUM!|#SPILL!',
                             options:{useRegex:true,maxResults:20},maxChars:1500})).ndjson);
const previewRanges=verificationMode?[...verificationSheets.map(n=>[n,'A1:F8']),
  ['VillageFieldReview','S1:Z6'],['VillageFieldReview','AA1:AJ6'],
  ['NeighborFieldReview','Q1:X6'],['NeighborFieldReview','Y1:AE6'],
  ['AcquisitionFollowup','N1:R6']]:coverageMode?coverageSheets.map(n=>[n,'A1:F8']):neighbors?neighborSheets.map(n=>[n,'A1:F8']):reconcile?
  [['ReconciledCoverage','A1:I5'],['IdentityReview','A1:F8'],['UBOSParents','A1:F8'],['ReconcileQA','A1:E8']]:
  [['GeoCoverage','A1:I5'],['GeoReview','A1:F8'],['GeoProject','A1:F6'],
   ['GeoSources','A1:D6'],['GeoQA','A1:E6'],['GeoDictionary','A1:C6']];
for (const [sheetName,range] of previewRanges) {
  const blob=await wb.render({sheetName,range,scale:1.5,format:'png'});
  await fs.writeFile(path.join(previews,sheetName+(verificationMode?'_'+range.replaceAll(':','_'):'')+'.png'),new Uint8Array(await blob.arrayBuffer()));
}
await (await SpreadsheetFile.exportXlsx(wb)).save(stage);
if (verificationMode) {
  const reopened=await SpreadsheetFile.importXlsx(await FileBlob.load(stage));
  const normalize=rows=>JSON.stringify(rows.map(r=>r.map(v=>v??'')));
  for (const n of verificationSheets) {
    const actual=reopened.worksheets.getItem(n).getUsedRange().values,
          expected=wb.worksheets.getItem(n).getUsedRange().values;
    if (normalize(actual)!==normalize(expected)) {
      for (let i=0;i<Math.max(actual.length,expected.length);i++)
        for(let j=0;j<Math.max(actual[i]?.length??0,expected[i]?.length??0);j++)
          if(JSON.stringify(actual[i]?.[j]??'')!==JSON.stringify(expected[i]?.[j]??''))
            throw new Error('Export/reopen value mismatch '+n+' row '+(i+1)+' column '+(j+1)+': '+
              JSON.stringify({actual:actual[i]?.[j],expected:expected[i]?.[j]}));
      throw new Error('Export/reopen range-size mismatch: '+n+' '+
        JSON.stringify({actual:[actual.length,actual[0]?.length],expected:[expected.length,expected[0]?.length]}));
    }
  }
}
if(digest(await fs.readFile(target))!==digest(before)) throw new Error('Workbook changed concurrently; staged export not promoted');
await fs.rename(stage,target);
console.log(JSON.stringify({workbook:target,newSheets:Object.keys(inputs),originalSheetsUnchanged:true,
  ...(verificationMode?{reviewWorksheetRoundtripVerified:true}:{})}));
