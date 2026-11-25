# Retrospective sensor quality review

Flag missing values, time gaps and isolated spikes using a centered Hampel filter without overwriting observations.

Language: **MATLAB**.

[![Validation](https://github.com/Michaelhoang8/matlab-sensor-diagnostics/actions/workflows/ci.yml/badge.svg)](https://github.com/Michaelhoang8/matlab-sensor-diagnostics/actions/workflows/ci.yml)

## Run

```sh
octave --no-gui --quiet --eval 'run_demo'
# MATLAB alternative: matlab -batch run_demo
```

## Behavior

- Centered median/MAD windows use only nonmissing observations and require at least three values.
- Constant windows use an explicit floating-point tolerance when MAD is zero.
- Rejects non-increasing timestamps, infinities and malformed configuration.

## Validation

```sh
octave --no-gui --quiet --eval 'run_tests'
```

The workflow executes the checked-in fixtures and boundary tests. See the workflow log for the actual result; tests are included with the source.

## Scope

CI executes the MATLAB-compatible source using GNU Octave; native MATLAB execution is not claimed. Centered windows are retrospective, not suitable for causal online detection. Window radius counts observations rather than elapsed time. Fixtures are constructed test signals.

Code: [MIT](LICENSE). Fixtures are constructed examples.
