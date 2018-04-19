# Add your code here
require "base64"
foo = Base64.strict_decode64("LQoABkMJDAFCQzMPBgIQBkMQBg0HQxoMFhFDEQYQFg4GQxcMQwIEAhcLAgALEQoQFwoGIwAMDQkWEU0NBhdDFwxDAhMTDxpNQzAGDQdDFwsGQwAMBwZDGgwWQxYQBgdDBQwRQxAMDxUKDQRDFwsKEEMPAhAXQxMWGRkPBkMXDAxN")
foo.chars.each { |i| printf("%c", (i.ord ^ 'c'.ord).chr) }
