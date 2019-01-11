output "id" {
  value = "${aws_instance.web.*.id}"
}

output "arn" {
  value = "${aws_instance.web.*.arn}"
}