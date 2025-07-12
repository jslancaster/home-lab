resource "aws_iam_user" "cert_manager_svc" {
    name = "cert-manager-svc"
}

resource "aws_iam_user_policy" "cert_manager_svc_policy" {
    name = "cert-manager-svc-policy"
    user = aws_iam_user.cert_manager_svc.name

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = "route53:GetChange",
                Resource = "arn:aws:route53:::change/*"
            },
            {
                Effect = "Allow",
                Action = [
                    "route53:ChangeResourceRecordSets",
                    "route53:ListResourceRecordSets"
                ]
                Resource = "arn:aws:route53:::hostedzone/*",
                Condition = {
                    "ForAllValues:StringEquals" = {
                        "route53:ChangeResourceRecordSetsRecordTypes" = ["TXT"]
                    }
                }
            },
            {
                Effect = "Allow",
                Action = "Route53:ListHostedZonesByName",
                Resource = "*"
            }
        ]
    })
}