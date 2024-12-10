reportextension 80501 "PTE Job Ticket 2 Rich Text" extends "PVS Job Ticket 2"
{
    dataset
    {
        add(LINE_DETAILS)
        {
            column(PTE_Comment_Rich_Text; GlobalRichText)
            { }

        }

        modify(LINE_DETAILS)
        {
            trigger OnAfterAfterGetRecord()
            begin
                GlobalRichText := PTEGetRichText();
            end;
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = '.\src\Job Ticket 2\layout\PTEJobTicket2.rdlc';
            Caption = 'Job Ticket Rich Text';
            Summary = 'Job Ticket with Rich Text Comments';
        }
    }

    var
        GlobalRichText: Text;
}