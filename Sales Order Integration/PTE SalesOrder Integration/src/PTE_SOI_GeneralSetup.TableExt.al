tableextension 80111 "PTE SOI General User setup" extends "PVS General setup"
{
    fields
    {
        field(80101; "PTE Sales Order Calc. Wait"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Salesorder Calculation Wait';
        }
    }
}