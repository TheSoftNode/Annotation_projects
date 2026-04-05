**PROMPT:**
why the following doesn't print a string as I expect?

echo "${statistics\_result\_string}" | awk \--assign environment=${environment} \--assign measurement\_name=${measurement\_name} '{

            output\_influxdb\_string="resource\_usage\_" environment

            output\_influxdb\_string+=",name=" measurement\_name

            output\_influxdb\_string+=" " $1 "\_count=" $2

            output\_influxdb\_string+=", " $1 "\_min=" $3

            output\_influxdb\_string+=", " $1 "\_10p=" $4

            output\_influxdb\_string+=", " $1 "\_25p=" $5

            output\_influxdb\_string+=", " $1 "\_50p=" $6

            output\_influxdb\_string+=", " $1 "\_75p=" $7

            output\_influxdb\_string+=", " $1 "\_90p=" $8

            output\_influxdb\_string+=", " $1 "\_max=" $9

            print output\_influxdb\_string

        }'
