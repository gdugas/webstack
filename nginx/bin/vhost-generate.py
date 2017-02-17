#!/usr/bin/env python

import argparse
import json
import os
import sys
import pystache


CWD = os.path.realpath(os.path.dirname(__file__))


def main():
    PARSER = argparse.ArgumentParser()
    
    CommandLink.init_parser(PARSER).set_defaults(run=CommandLink.run)

    ARGS = PARSER.parse_args()
    ARGS.run(ARGS)


class CommandLink:

    bool_false = lambda x: not x.lower() in ["0", "no", "not", "ko", "false"]
    bool_true = lambda x: x.lower() in ["1", "yes", "true", "ok"]

    @staticmethod
    def init_parser(parser):
        parser.add_argument('service_name', help="The docker service to link")

        parser.add_argument('domains', 
                        nargs='+',
                        help="List of domain names, comma separated")
        
        parser.add_argument('--force-https',
                        type=CommandLink.bool_false,
                        default=True)
        
        parser.add_argument('--http-port',
                        type=int,
                        default=80)

        parser.add_argument('--https-port',
                        type=int,
                        default=443)
        
        parser.add_argument('--service-port',
                        type=int,
                        default=9000)
        
        parser.add_argument('--ssl-cert-path',
                        required=True)
        
        parser.add_argument('--ssl-key-path',
                        required=True)
        
        parser.add_argument('-t', '--template',
                        type=file,
                        default=os.path.join(CWD, "/etc/nginx/conf.d/vhost.conf.tpl"))
        
        return parser
    
    
    @staticmethod
    def run(args):
        sys.stdout.write(pystache.render(args.template.read(), args))


main()