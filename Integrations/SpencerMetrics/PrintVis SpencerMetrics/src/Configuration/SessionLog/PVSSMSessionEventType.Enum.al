namespace PrintVis.SpencerMetrics.Configuration;

enum 80290 "PVS SM Session Event Type"
{
    Caption = 'Session Event Type';
    Access = Internal;

    value(0; Start)
    {
        Caption = 'Start';
    }
    value(1; Stop)
    {
        Caption = 'Stop';
    }
}
