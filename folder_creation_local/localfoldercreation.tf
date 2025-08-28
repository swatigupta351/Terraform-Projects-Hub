# HCL code for Create local Folder . 

resource "null_resource" "create_folder" {

 provisioner "local-exec" {

command = " mkdir -p ./Demo"

 }

}

resource "local_file" "test_file" {

filename = "./Demo/hello.txt"
content = " Hello Swati . "
depends_on = [null_resource.create_folder]

}
