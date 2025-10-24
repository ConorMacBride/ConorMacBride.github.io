# frozen_string_literal: true
# Plugin: generate grouped experiences data for CV/home templates
# Applies to multiple collections (experience, education, volunteering)
# Places structured arrays into:
#   site.data['grouped_experience']
#   site.data['grouped_education']
#   site.data['grouped_volunteering']

require 'jekyll'
require 'time'
require 'ostruct'

module Jekyll
  class GroupedExperienceGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # 🔹 Define which collections to process
      collections = %w[experience education volunteering]

      collections.each do |collection_name|
        docs = get_docs(site, collection_name)
        next if docs.empty?

        result = process_docs(site, docs, collection_name)
        site.data["grouped_#{collection_name}"] = result
      end
    end

    private

    # 🔹 Extracted from your current code — handles normalizing source docs
    def get_docs(site, collection_name)
      docs =
        if site.collections.key?(collection_name)
          site.collections[collection_name].docs
        elsif site.data.key?(collection_name)
          site.data[collection_name]
        else
          []
        end

      docs.map do |d|
        if d.respond_to?(:data)
          d
        elsif d.is_a?(Hash)
          OpenStruct.new(
            data: d,
            content: (d['content'] || ''),
            basename_without_ext: (d['slug'] || d['id'] || d['path'] || '')
          )
        else
          d
        end
      end
    end

    # 🔹 All your existing grouping, sorting, date handling, etc.
    def process_docs(site, docs, collection_name)
      sorted = docs.sort_by do |doc|
        dd = (doc.data['date'] || doc.data['start'])
        begin
          if dd.respond_to?(:to_time)
            dd.to_time
          else
            Time.parse(dd.to_s)
          end
        rescue
          Time.at(0)
        end
      end.reverse

      grouped = sorted.group_by { |doc| (doc.data['organisation'] || '').to_s }
      md_converter = site.find_converter_instance(Jekyll::Converters::Markdown)

      result = []
      idx = 0

      grouped.each do |org, items|
        next if org.to_s.strip.empty?
        items = items.reject { |i| i.data && i.data['subentry'] }
        next if items.empty?

        starts = items.map { |i| safe_time(i.data['start']) }.compact
        ends = items.map { |i| safe_time(i.data['date']) }.compact

        earliest = starts.min
        latest = ends.max || earliest

        start_str = earliest ? earliest.strftime('%b %Y') : ''
        latest_str = if latest && latest.to_i > 5_000_000_000
                       'Present'
                     elsif latest
                       latest.strftime('%b %Y')
                     else
                       start_str
                     end

        group_datestring =
          if start_str == latest_str
            start_str
          else
            "#{start_str} &mdash; #{latest_str}"
          end

        group_has_content = items.any? { |i| (i.content || '').strip.length > 20 }

        group_items = items.map do |doc_item|
          id =
            if doc_item.respond_to?(:basename_without_ext)
              doc_item.basename_without_ext
            elsif doc_item.data['path']
              File.basename(doc_item.data['path'], '.md')
            else
              (doc_item.data['id'] || doc_item.data['slug'] || '')
            end

          start_t = safe_time(doc_item.data['start'])
          end_t = safe_time(doc_item.data['date'])

          start_str_i = start_t ? start_t.strftime('%b %Y') : ''
          end_str_i = if end_t && end_t.to_i > 5_000_000_000
                        'Present'
                      elsif end_t
                        end_t.strftime('%b %Y')
                      else
                        ''
                      end

          datestring_i =
            if start_str_i == end_str_i || end_str_i.empty?
              start_str_i
            else
              "#{start_str_i} &mdash; #{end_str_i}"
            end

          raw_content = doc_item.content || ''

          # Build a Liquid renderer for this piece of content
          liquid_renderer = site.liquid_renderer
          context = site.site_payload.merge({ "page" => doc_item.data })

          # Parse and render the content as Liquid
          liquid_rendered = site.liquid_renderer
            .file(doc_item.respond_to?(:path) ? doc_item.path : "(inline)")
            .parse(raw_content.to_s)
            .render!(
              site.site_payload.merge({ "page" => doc_item.data }),
              registers: { site: site, page: doc_item }
            )

          content_html = md_converter.convert(liquid_rendered)

          {
            'id' => id.to_s,
            'is_first' => doc_item == items.first,
            'is_last' => doc_item == items.last,
            'role' => (doc_item.data['role'] || '').to_s,
            'start_str' => start_str_i,
            'end_str' => end_str_i,
            'datestring' => datestring_i,
            'content_html' => content_html,
            'noexpand' => !!doc_item.data['noexpand'],
            'mobcollapse' => !!doc_item.data['mobcollapse'],
            'subentry' => !!doc_item.data['subentry'],
            'link' => doc_item.data['link'],
            'homepage' => !(doc_item.data.key?('homepage') && doc_item.data['homepage'] == false)
          }
        end

        idx += 1
        expand_id = "expand-#{collection_name}-#{idx}"
        group_homepage = !(items.first.data.key?('homepage') && items.first.data['homepage'] == false)

        result << {
          'organisation' => org,
          'organisation_upcase' => org.to_s.upcase,
          'items' => group_items,
          'is_group' => group_items.size > 1,
          'itemid' => (group_items.first && group_items.first['id']) || "org-#{idx}",
          'noexpand' => group_items.first ? group_items.first['noexpand'] : false,
          'mobcollapse' => group_items.first ? group_items.first['mobcollapse'] : false,
          'group_role' => (group_items.first ? group_items.first['role'] : ''),
          'group_has_content' => group_has_content,
          'group_datestring' => group_datestring,
          'expand_id' => expand_id,
          'homepage' => group_homepage
        }
      end

      result
    end

    def safe_time(v)
      return nil if v.nil?
      return v if v.respond_to?(:to_time)
      begin
        Time.parse(v.to_s)
      rescue
        nil
      end
    end
  end
end
