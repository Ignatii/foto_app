# require 'active_interaction'
require 'nokogiri'
require 'csv'
# add functionality to show needed images
module Admin
  class ImagesImport < ActiveInteraction::Base
    string :mode

    validates :mode, presence: true, inclusion: { in: %w[xml xls csv],
                                                  message: 'Not valid' }

    def execute
      case mode
      when 'xml'
        import_xml
      when 'csv'
        import_csv
      when 'xls'
        import_xls
      end
    end

    def import_xml
      @images_xml = Image.all.order(:likes_img)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.images do
          @images_xml.each do |image|
            user = image.user
            xml.image do
              xml.id image.id
              xml.image_name image.image
              xml.created_at image.created_at
              xml.state image.aasm_state
              xml.title image.title_img
              xml.tags image.tags
              xml.likes image.likes_img
              xml.user do
                xml.user_id user.id
                xml.name_user user.name
                xml.email user.email
              end
              xml.comments do
                comments = image.comments
                if comments.count.positive?
                  comments.each do |comment|
                    xml.comment_xml do
                      xml.comment_id comment.id
                      xml.user_id comment.user_id
                      xml.body comment.body
                      xml.created_at comment.created_at
                    end
                  end
                end
              end
            end
          end
        end
      end
      File.open(Rails.root.join('public', 'import', 'images.xml'), 'w+') do |f|
        f.write(builder.to_xml)
      end
    end

    def import_csv
      CSV.open(path, 'wb') do |csv|
        csv << images_her.attribute_names
        images_her.each do |image|
          csv << image.attributes.values
        end
      end
    end

    def import_xls
      File.open(path, 'w+') do |f|
        colums = %i[idd image i_u_id i_created_at state title tags likes u_id name email c_id comment_text c_created_at]
        write_info = images_her.to_a.to_xls(only: colums)
        f.write(write_info.force_encoding('utf-8').encode)
      end
    end

    def path
      @path = Rails.root.join('public', 'import', "images.#{mode}")
    end

    def images_her
      @images_her = Her.all
    end
  end
end
