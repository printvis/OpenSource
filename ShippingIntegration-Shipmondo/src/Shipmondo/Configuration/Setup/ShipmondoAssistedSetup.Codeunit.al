namespace PrintVis.OpenSource.Shipmondo.Configuration;

using System.Environment.Configuration;

codeunit 80190 "SISM Assisted Setup"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure RegisterAssistedSetup()
    var
        GuidedExperience: Codeunit "Guided Experience";
        ShipmondoSetupDescriptionTxt: Label 'Set up integration with Shipmondo for shipping management';
        ShipmondoSetupShortTitleTxt: Label 'Set up Shipmondo Integration';
        ShipmondoSetupTitleTxt: Label 'Set up Shipmondo Integration';
    begin
        GuidedExperience.InsertManualSetup(
            ShipmondoSetupTitleTxt,
            ShipmondoSetupShortTitleTxt,
            ShipmondoSetupDescriptionTxt,
            5,
            ObjectType::Page,
            Page::"SISM Assisted Setup",
            "Manual Setup Category"::Service,
            '');
    end;
}