output public_ip {
  value = "${aws_instance.suguamilnx.public_ip}"
}

/*
data "aws_subnet_ids" "example" {

	vpc_id = "$(aws_vpc.tform_sugu_vpc.id}"
}

data "aws_subnet" "example" {
	count = "${length(data.aws_subnet_ids.example.ids)}"
	id = "${data.aws_subnet_id.example.ids[count.index]}"
}

output "subnet_cidr_blocks" {
	value = ["${data.aws_subnet.example.*.cidr_block}"]
}
*/

