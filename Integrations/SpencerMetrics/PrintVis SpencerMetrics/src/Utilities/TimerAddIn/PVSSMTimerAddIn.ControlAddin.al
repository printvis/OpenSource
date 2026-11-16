namespace PrintVis.SpencerMetrics.Utilities;

controladdin "PVS SM Timer AddIn"
{
    HorizontalStretch = false;
    RequestedHeight = 1;
    RequestedWidth = 1;
    Scripts = 'src/Utilities/TimerAddIn/timer.js';
    VerticalStretch = false;

    event Ready();
    event OnTick();
    procedure Start(IntervalMs: Integer)
    procedure Stop()
}