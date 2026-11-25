function report = sensor_qc(time, values, radius, threshold, max_gap)
%SENSOR_QC Flag isolated spikes without overwriting source observations.
% Centered Hampel windows are retrospective, not a causal streaming filter.
  if ~isnumeric(time) || ~isnumeric(values) || ~isreal(time) || ~isreal(values)
    error('sensor_qc:input', 'Time and values must be real numeric vectors.');
  end
  if ~isvector(time) || ~isvector(values) || numel(time) ~= numel(values) || isempty(time)
    error('sensor_qc:shape', 'Expected nonempty equal-length vectors.');
  end
  time = time(:); values = values(:);
  if any(~isfinite(time)) || any(diff(time) <= 0) || any(isinf(values))
    error('sensor_qc:input', 'Times must increase strictly; values may be NaN but not Inf.');
  end
  if ~isscalar(radius) || ~isfinite(radius) || radius < 1 || fix(radius) ~= radius
    error('sensor_qc:radius', 'Radius must be a positive integer.');
  end
  if ~isscalar(threshold) || ~isfinite(threshold) || threshold <= 0 || ~isscalar(max_gap) || ~isfinite(max_gap) || max_gap <= 0
    error('sensor_qc:threshold', 'Threshold and maximum gap must be finite and positive.');
  end
  count = numel(values);
  baseline = NaN(count, 1); scale = NaN(count, 1); spikes = false(count, 1);
  for index = 1:count
    window = values(max(1,index-radius):min(count,index+radius));
    window = window(~isnan(window));
    if numel(window) < 3 || isnan(values(index)), continue; end
    baseline(index) = median(window);
    scale(index) = 1.4826 * median(abs(window - baseline(index)));
    % A constant window has MAD zero; compare against a numerical tolerance.
    bound = max(threshold * scale(index), 16 * eps(max(1,abs(baseline(index)))));
    spikes(index) = abs(values(index) - baseline(index)) > bound;
  end
  report.time = time; report.original = values;
  report.missing = isnan(values); report.spikes = spikes;
  report.baseline = baseline; report.robust_scale = scale;
  report.gap_after = find(diff(time) > max_gap);
  report.summary = [count, sum(report.missing), sum(spikes), numel(report.gap_after)];
end
