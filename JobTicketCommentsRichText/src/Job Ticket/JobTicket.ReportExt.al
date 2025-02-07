reportextension 80500 "PTE Job Ticket Rich Text" extends "PVS Job Ticket"
{
    dataset
    {
        modify(LINE_DETAILS)
        {
            trigger OnAfterAfterGetRecord()
            begin
                GlobalJobTicketRichText.GetNextEntry(GlobalBufferTmp);
                GlobalRichText := GlobalBufferTmp.PTEGetRichText();
            end;
        }
        add(LINE_DETAILS)
        {
            column(PTECommentRichText; GlobalRichText)
            { }
            column(PTEDepartmentName; GlobalBufferTmp."PTE Department Name")
            { }
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = '.\src\Job Ticket\layout\PTEJobTicket.rdlc';
            Caption = 'Job Ticket Rich Text';
            Summary = 'Job Ticket with Rich Text Comments';
        }
    }

    var
        GlobalBufferTmp: Record "PVS Sorting Buffer" temporary;
        GlobalJobTicketRichText: Codeunit "PTE Job Ticket Rich Text";
        GlobalRichText: Text;

}