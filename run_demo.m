function run_demo()
  data = dlmread('fixtures/sensor.csv', ',', 1, 0);
  report = sensor_qc(data(:,1), data(:,2), 2, 3, 1.5);
  fprintf('observations=%d missing=%d spikes=%d time_gaps=%d\n', report.summary);
  fprintf('spike_times: '); fprintf('%g ', report.time(report.spikes)); fprintf('\n');
  output = [report.time report.original double(report.missing) double(report.spikes) report.baseline report.robust_scale];
  dlmwrite('sensor-review.csv', output, 'delimiter', ',', 'precision', 12);
end
