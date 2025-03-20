Table 80230 "PVS UPG Workflow Partner Respo"
//Table 6010917 "PVS Workflow Partner Responses"
{
    Caption = 'Workflow Partner Response';


    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; SenderID; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'SenderID';
        }
        field(3; "Device Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PV Device Code';
        }
        field(4; "Controller Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PV Controller Code';
        }
        field(5; DeviceID; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'DeviceID';
        }
        field(6; "Event TimeStamp"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'TimeStamp';
        }
        field(7; "JobPhase JobID"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'JobPhase JobID';
        }
        field(8; "JobPhase JobPartID"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'JobPhase JobPartID';
        }
        field(9; "Event System"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'System';
            OptionCaption = 'JDF/JMF,JDF Intent,CP2000,DCM,AutoCount';
            OptionMembers = "JDF/JMF","JDF Intent",CP2000,DCM,AutoCount;
        }
        field(10; "PVS ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'ID';
        }
        field(11; Job; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Job';
        }
        field(12; "Plan ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Plan ID';
        }
        field(13; "Job Item No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Job Item No.';
        }
        field(14; "Job Item Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Job Item Entry No.';
        }
        field(15; "Process ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'ProcessID';
        }
        field(18; "Device TotalProductionCounter"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Device TotalProduction Counter';
        }
        field(19; ID; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'ID';
        }
        field(20; "Device Status Text"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Device Status Text';
        }
        field(21; "Device StatusDetails Text"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Device StatusDetails Text';
        }
        field(22; "JobPhase Status Text"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'JobPhase Status Text';
        }
        field(23; "JobPhase StatusDetails Text"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'JobPhase StatusDetails Text';
        }
        field(24; "JobPhase Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'JobPhase Amount';
        }
        field(25; "JobPhase Waste"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'JobPhase Waste';
        }
        field(26; JobPhaseCounter; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'JobPhase Counter';
            DecimalPlaces = 0 : 0;
        }
        field(27; "Sheet ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'SheetID';
        }
        field(30; "JobPhase Included"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'JobPhase Included';
            InitValue = false;
        }
        field(40; EmployeeID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'EmployeeID';
        }
        field(41; "JobPhase PercentCompleted"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'JobPhase Percent Completed';
        }
        field(42; "JobPhase RestTime"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'JobPhase RestTime';
        }
        field(43; "JobPhase Speed"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'JobPhase Speed';
        }
        field(44; "JobPhase Start DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'JobPhase Start DateTime';
        }
        field(45; "JobPhase PhaseAmount"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'JobPhase PhaseAmount';
        }
        field(46; "JobPhase TotalAmount"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'JobPhase TotalAmount';
        }
        field(47; "Device OperationMode"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Device OperationMode';
        }
        field(48; "Device Condition"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Device Condition';
        }
        field(49; "JobPhase End DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'JobPhase End DateTime';
        }
        field(50; "Costing Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'PV Costing Type';
            OptionCaption = 'Time,Materials';
            OptionMembers = Time,Materials;
        }
        field(51; "Cost Center Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PV Cost Center Code';
        }
        field(52; "Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order No.';
        }
        field(53; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PV Item No.';
        }
        field(54; "Event Comment"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment';
        }
        field(55; "Work Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Code';
        }
        field(56; "Event Text"; Code[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Text';
        }
        field(60; "Resource Actual Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Resource Actual Amount';
        }
        field(61; "Resource Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Resource Amount';
        }
        field(62; "Resource AvailableAmount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Resource AvailableAmount';
        }
        field(63; "Resource Level"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Resource Level';
        }
        field(64; "Resource Location"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource Location';
        }
        field(65; "Resource ModuleID"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource ModuleID';
        }
        field(66; "Resource ModuleIndex"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource ModuleIndex';
        }
        field(67; "Resource ResourceName"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource ResourceName';
        }
        field(68; "Resource ProcessUsage"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource ProcessUsage';
        }
        field(69; "Resource ProductID"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource ProductID';
        }
        field(70; "Resource Status"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Resource Status';
        }
        field(71; "Resource Unit"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource Unit';
        }
        field(72; CostCenterID; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource CostCenterID';
        }
        field(73; CostCenterName; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource CostCenterName';
        }
        field(80; QueueEntryID; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'QueueEntryID';
        }
        field(81; "ReturnQueueEntry Aborted"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'returnQueueEntry Aborted';
        }
        field(82; "ReturnQueueEntry Completed"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'returnQueueEntry Completed';
        }
        field(83; "ReturnQueueEntry Priority"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'returnQueueEntry Priority';
        }
        field(84; "ReturnQueueEntry URL"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'returnQueueEntry URL';
        }
        field(98; "Device JMFURL"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Device JMF URL';
        }
        field(99; "File BLOB"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'File BLOB';
        }
        field(100; "DateTime Received"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'DateTime Received';
        }
        field(101; "File Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Filename';
        }
        field(102; "Response Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Response Type';
            OptionCaption = ' ,Status,Resource,Notification,Occupation';
            OptionMembers = " ",Status,Resource,Notification,Occupation;
        }
        field(103; "Response Sub Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Response Sub Type';
            OptionCaption = ' ,DeviceStatus,JobPhase,Resource,Employee,ReturnQueueEntry';
            OptionMembers = " ",DeviceStatus,JobPhase,Resource,Employee,ReturnQueueEntry;
        }
        field(200; "PVS Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'PV Status';
            OptionCaption = 'New,Processed,Error';
            OptionMembers = New,Processed,Error;
        }
        field(201; "Posted To Journal"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PV Posted to Journal';
        }
        field(202; "Posted DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'PV Posted Date Time';
        }
        field(203; "Error Text"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'PV Error Text';
        }
        field(204; "Message Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'PV Message Status';
            OptionCaption = '', Comment = ' ,WithControllerInfoOnly,WithDeviceInfo,WithControllerDeviceFromEstimate';
            OptionMembers = " ",WithControllerInfoOnly,WithDeviceInfo,WithControllerDeviceFromEstimate;
        }
        field(210; "File Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'File date';
        }
        field(211; "File Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'File time';
        }
        field(212; "File Size"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'File Size';
        }
        field(300; "Device Type"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Device Type';
        }
        field(301; "Device Manufacturer"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Device Manufacturer';
        }
        field(400; EmployeeShift; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Shift';
        }
        field(401; EmployeeCostCenterID; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Cost Center ID';
        }
        field(402; EmployeeCostCenterName; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Cost Center Name';
        }
        field(403; EmployeeFirstName; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee First Name';
        }
        field(404; EmployeeFamilyName; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Family Name';
        }
        field(405; EmployeeRoleApprentice; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Role Apprentice';
        }
        field(406; EmployeeRoleAssistant; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Role Assistant';
        }
        field(407; EmployeeRoleCraftsman; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Role Craftsman';
        }
        field(408; EmployeeRoleCSR; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Role CSR';
        }
        field(409; EmployeeRoleManager; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Role Manager';
        }
        field(410; EmployeeRoleMaster; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Role Master';
        }
        field(411; EmployeeRoleOperator; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Role Operator';
        }
        field(412; EmployeeRoleShiftLeader; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Role ShiftLeader';
        }
        field(413; EmployeeRoleStandBy; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Role Standby';
        }

        field(601; "Body Parts In Transit"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Bodyparts In-Transit';
            Editable = false;
        }
        field(602; "Original JMF File"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Original JMF File';
        }
        field(700; "Device Status Text Backup"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Device Status Text Backup';
        }
        field(701; "Device StatusDetails Text Back"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Device StatusDetails Text Back';
        }
        field(703; "Device Status Activity Backup"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Device Status Activity Backup';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }

    }
}

