go tool pprof -pdf isubata http://localhost:6060/debug/pprof/profile?seconds=60 > pprof.pdf
slackcat --channel isucon-log pprof.pdf

