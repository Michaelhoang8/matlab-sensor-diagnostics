function run_tests()
  values = [10 10 10 10 80 10 10 10 10];
  report = sensor_qc(0:8, values, 2, 3, 1.5);
  assert(isequal(find(report.spikes), 5));
  assert(isequal(report.original, values(:)));
  assert(isequal(report.summary, [9 0 1 0]));
  assert(all(report.robust_scale == 0));
  missing = sensor_qc([0 1 2 8 9], [2 NaN 2 2 2], 2, 3, 2);
  assert(isequal(missing.gap_after, 3));
  assert(missing.missing(2) && ~missing.spikes(2));
  small = sensor_qc([0 1], [1 10], 1, 3, 1);
  assert(~any(small.spikes) && all(isnan(small.baseline)));
  all_missing = sensor_qc(0:3, NaN(1,4), 2, 3, 2);
  assert(~any(all_missing.spikes) && sum(all_missing.missing) == 4);
  assert(rejects(@() sensor_qc([0 0], [1 2], 1, 3, 1)));
  assert(rejects(@() sensor_qc([0 1], [1 Inf], 1, 3, 1)));
  assert(rejects(@() sensor_qc([0 1], [1 2], 0, 3, 1)));
  assert(rejects(@() sensor_qc([0 1], [1 2], 1, 0, 1)));
  assert(rejects(@() sensor_qc([0 1], [1 2 3], 1, 3, 1)));
  assert(rejects(@() sensor_qc([0 NaN], [1 2], 1, 3, 1)));
  fprintf('14 sensor quality checks passed\n');
end
function result = rejects(action)
  result = false;
  try, action(); catch, result = true; end
end
