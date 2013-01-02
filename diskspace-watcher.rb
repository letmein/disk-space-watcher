#!/usr/bin/ruby

device = ARGV[0] || raise("Device name required")
limit  = ARGV[1] || raise("Space limit required")
to     = ARGV[3] || raise("Email address required")
domain = ARGV[4] || raise("Domain name required")

raise "Invalid format: #{limit}" unless limit =~ /^\d+(M|G)$/

SIZE_MAP = {
  'M' => 1024,
  'G' => 1024*1024
}

limit_unit = limit[-1, 1]
limit_size = limit.to_i
limit_in_bytes = limit_size * SIZE_MAP[limit_unit]

filesystem, size, used, avail, percents_used, mounted_on = `df #{device}`.lines.to_a.last.split

mail_body = <<-TEXT
Subject: Less than #{limit} free space left on #{domain}!
#{`df #{device} -hP`}
TEXT

if avail.to_i < limit_in_bytes
  `echo "#{mail_body}" | exim `
end
