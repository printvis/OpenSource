permissionset 80154 "SINS All"
{
    Assignable = true;
    Caption = 'nShift Integration';
    Permissions = table "SINS Delivery Setup" = X,
tabledata "SINS Delivery Setup" = RIMD,
        table "SINS Ship Setup" = X,
        tabledata "SINS Ship Setup" = RIMD,
        codeunit "SINS Delivery API Client" = X,
        codeunit "SINS Delivery Implementation" = X,
        codeunit "SINS Delivery Req. Builder" = X,
        codeunit "SINS Delivery Resp. Handler" = X,
        codeunit "SINS Delivery Shpt. Mgt." = X,
        codeunit "SINS Delivery Validation" = X,
        codeunit "SINS Event Handler" = X,
        codeunit "SINS General Validation" = X,
        codeunit "SINS Ship API Client" = X,
        codeunit "SINS Ship Implementation" = X,
        codeunit "SINS Ship Req. Builder" = X,
        codeunit "SINS Ship Resp. Handler" = X,
        codeunit "SINS Ship Shpt. Mgt." = X,
        codeunit "SINS Ship Validation" = X,
        page "SINS Delivery Setup" = X,
        page "SINS Ship Setup" = X;
}