$ErrorActionPreference = 'Stop'
$project = Split-Path $PSScriptRoot -Parent
$work = Join-Path $PSScriptRoot 'work'
$tools = @{}
foreach ($name in 'xvhdl', 'xelab', 'xsim') {
    $tools[$name] = if ($env:VIVADO_BIN) {
        Join-Path $env:VIVADO_BIN "$name.bat"
    } else {
        (Get-Command "$name.bat" -ErrorAction Stop).Source
    }
}

$sources = @(
    'rtl/transmitter.vhd'
    'examples/debounce.vhd'
    'examples/top.vhd'
    'tb/tb_transmitter.vhd'
) | ForEach-Object { Join-Path $project $_ }

New-Item -ItemType Directory -Path $work -Force | Out-Null
Push-Location -LiteralPath $work
try {
    & $tools.xvhdl -2008 @sources
    if ($LASTEXITCODE -ne 0) { throw 'xvhdl failed' }

    & $tools.xelab tb_transmitter -s uart_tx_sim
    if ($LASTEXITCODE -ne 0) { throw 'xelab failed' }

    'run 5 us', 'quit' | Set-Content -Path run.tcl -Encoding ascii
    & $tools.xsim uart_tx_sim -tclbatch run.tcl
    $done = Select-String -LiteralPath xsim.log -Pattern 'Failure: SIM DONE' -Quiet
    if (-not $done) { throw 'Testbench did not reach SIM DONE' }
}
finally {
    Pop-Location
}
