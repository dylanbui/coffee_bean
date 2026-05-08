require 'net/http'
require 'json'
require 'uri'

# Get arguments from command line
env, status_android, status_ios, notes_path, webhook_url = ARGV

def get_lark_card(env, s_android, s_ios, notes_path)
  release_notes = File.read(notes_path) rescue "No notes available."

  # Determine color template: Red if any fail, Blue if all success
  is_all_success = (s_android == "success" || s_android == "skipped") && (s_ios == "success" || s_ios == "skipped")
  header_template = is_all_success ? "blue" : "red"

  {
    msg_type: "interactive",
    card: {
      header: {
        template: header_template,
        title: { content: "🚀 BUILD REPORT - #{env.upcase}", tag: "plain_text" }
      },
      elements: [
        { tag: "div", text: { content: "**🤖 Android:** #{s_android.upcase}", tag: "lark_md" } },
        { tag: "div", text: { content: "**🍎 iOS:** #{s_ios.upcase}", tag: "lark_md" } },
        { tag: "hr" },
        { tag: "div", text: { content: "**📝 Release Notes:**\n#{release_notes}", tag: "lark_md" } },
        { tag: "note", elements: [{ content: "Build System by Dylan Bui", tag: "plain_text" }] }
      ]
    }
  }
end

uri = URI.parse(webhook_url)
payload = get_lark_card(env, status_android, status_ios, notes_path)

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' => 'application/json'})
request.body = payload.to_json
http.request(request)