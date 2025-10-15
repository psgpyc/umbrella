data "archive_file" "lambda_zip" {
    type = "zip"
    source_dir = var.source_dir
    output_path = var.output_path
  
}

resource "aws_lambda_function" "this" {

    function_name = var.lambda_func_name
    
    filename = data.archive_file.lambda_zip.output_path

    source_code_hash = data.archive_file.lambda_zip.output_base64sha256

    role = var.lambda_iam_execution_role

    handler = "main.lambda_handler"

    runtime = "python3.12"
    timeout = 10
    memory_size = 256
    architectures = ["arm64"]

    environment {
      variables = {
        "stage": var.stage_name
      }
    }

}