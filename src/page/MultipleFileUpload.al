page 50140 "Multiple File Upload"
{
    PageType = NavigatePage;
    Caption = 'Permite adjuntar varios documentos';
    UsageCategory = Tasks;
    ApplicationArea = All;
    Extensible = false;

    layout
    {
        area(Content)
        {
            usercontrol(FileUploader; MultipleUpload)
            {
                ApplicationArea = All;

                trigger OnControlAddInReady()
                begin
                    CurrPage.Update(false);
                end;

                trigger FileUploaded(filesJson: Text)
                var
                    Files: JsonArray;
                    FileObject: JsonObject;
                    JsonToken: JsonToken;
                    i: Integer;
                    FileName: Text;
                    FileContent: Text;
                begin
                    if Files.ReadFrom(filesJson) then begin
                        for i := 0 to Files.Count - 1 do begin
                            Files.Get(i, JsonToken);
                            FileObject := JsonToken.AsObject();

                            FileObject.Get('name', JsonToken);
                            FileName := JsonToken.AsValue().AsText();
                            FileObject.Get('content', JsonToken);
                            FileContent := JsonToken.AsValue().AsText();

                            ProcessFile(FileName, FileContent);
                        end;
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Accept)
            {
                ApplicationArea = All;
                Caption = 'Aceptar';
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CurrPage.FileUploader.submitFiles();
                end;
            }
            action(Cancel)
            {
                ApplicationArea = All;
                Caption = 'Cancelar';
                Image = Cancel;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    local procedure ProcessFile(FileName: Text; FileContent: Text)
    begin
        Message('Archivo procesado: %1', FileName);
    end;
}

controladdin MultipleUpload
{
    Scripts = 'Scripts/MultipleUpload.js';
    StartupScript = 'Scripts/MultipleUpload.js';
    HorizontalStretch = true;
    VerticalStretch = true;
    RequestedHeight = 300;
    MinimumHeight = 300;

    event OnControlAddInReady();
    event FileUploaded(filesJson: Text);
    procedure submitFiles();
}