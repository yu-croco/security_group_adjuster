# SecurityGroupAdjuster
- This Ruby repository is for changing one of your EC2 security groups' inbound ip address.
- In my environment, our team restricts inbound access agains EC2, but our IP address at office was not fixed one.
- So I needed to change it when WiFi router changes its IP address.
- You can solve this problem with this repository.

## How to use
1. clone this repository to your local working space.
2. bundle install
3. configure your target resource at `config/aws.yml`
4. run `ruby main.rb`

## Licence
MIT license
