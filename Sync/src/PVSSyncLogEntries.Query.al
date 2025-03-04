Query 80200 "PVS Sync Log Entries"
{
    Caption = 'PVS Sync Log Entries', Locked = true;
    QueryType = Normal;

    elements
    {
        dataitem(PVSSyncLogEntry; "PVS Sync Log Entry")
        {
            column(SortingOrder; "Sorting Order")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            filter(SourceBusinessGroup; "Source Business Group")
            {
            }
            filter(DestinationBusinessGroup; "Destination Business Group")
            {
            }
            filter(Status; Status)
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
