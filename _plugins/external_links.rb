# frozen_string_literal: true
# ...existing code...
require 'jekyll'
require 'nokogiri'
require 'uri'

# This plugin runs after pages and documents are rendered. It parses the HTML
# and sets target="_blank" and rel="noopener noreferrer" on external links
# (http/https and scheme-relative // links). It skips:
# - anchor links (#...)
# - mailto: and tel:
# - relative links (starting with / or .)
# - links that point to the site's own host (if site.url is configured)

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # Only operate on HTML output
  unless doc.respond_to?(:output) && doc.output.is_a?(String)
    next
  end
  next unless doc.output_ext == '.html' || doc.output.include?('<a ')

  begin
    site = doc.site
    site_url = site.config['url'].to_s
    site_host = nil
    begin
      site_host = URI(site_url).host if site_url && !site_url.empty?
    rescue URI::InvalidURIError
      site_host = nil
    end

    html = doc.output
    fragment = Nokogiri::HTML::DocumentFragment.parse(html)
    modified = false

    fragment.css('a[href]').each do |a|
      href = a['href']
      next if href.nil? || href.strip.empty?
      href = href.strip

      # Skip anchors and protocols we don't want to change
      next if href.start_with?('#') || href.start_with?('mailto:') || href.start_with?('tel:')

      # Skip relative links
      next if href.start_with?('/') || href.start_with?('.')

      # Parse scheme-relative and absolute URLs
      uri = nil
      begin
        uri = if href.start_with?('//')
                URI("http:#{href}")
              else
                URI(href)
              end
      rescue URI::InvalidURIError
        next
      end

      # Only handle http(s)
      next unless uri && %w[http https].include?(uri.scheme)

      # If site host is known and matches the link's host, treat as internal
      if site_host && uri.host == site_host
        next
      end

      # Set target and rel attributes for external links
      if a['target'] != '_blank'
        a.set_attribute('target', '_blank')
        modified = true
      end

      rel_vals = (a['rel'] || '').split(/\s+/).reject(&:empty?)
      %w[noopener noreferrer].each do |v|
        rel_vals << v unless rel_vals.include?(v)
      end
      new_rel = rel_vals.join(' ')
      if (a['rel'] || '') != new_rel
        a.set_attribute('rel', new_rel)
        modified = true
      end
    end

    if modified
      # Replace the document output with the modified HTML fragment
      doc.output = fragment.to_html
    end
  rescue StandardError => e
    Jekyll.logger.warn "external_links plugin:", "Failed to process #{doc.respond_to?(:relative_path) ? doc.relative_path : doc.inspect}: #{e.message}"
  end
end
