module ApplicationHelper

  # 登录弹窗开始
  def resource_name
    :user
  end

  def resource
      @resource ||= User.new
  end

  def resource_class
      User
  end

  def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
  end
  # 登录弹窗结束


  # markdown方法开始
  def markdown(text)
        renderer_options = {
            hard_wrap: true,
            filter_html: true
        }

        markdown_options = {
            autolink: true,
            no_intra_emphasis: true,
            fenced_code_blocks: true,
            lax_html_blocks: true,
            strikethrough: true,
            superscript: true
        }

        renderer = HTMLwithRouge.new(renderer_options)
        Redcarpet::Markdown.new(renderer, markdown_options).render(text).html_safe
    end

    class HTMLwithRouge < Redcarpet::Render::HTML

        INDENT = " " * 2

        def block_code(code, metadata)
            language, filename = metadata.split(":") if metadata

            lexer = find_lexer_with(language)

            formatter = Rouge::Formatters::HTML.new
            formatter2 = Rouge::Formatters::HTMLTable.new(formatter, opts={})

            rows = []
            rows << %(<div class="code-block">)
            if filename
                rows << %(#{INDENT}<div class="code-header">)
                rows << %(#{INDENT * 2}<span>#(filename)</span>)
                rows << %(#{INDENT}</div>)
            end
            rows << %(#{INDENT}<div class="code-body">)
            rows << %(#{INDENT * 2}#{formatter2.format(lexer.lex(code))})
            rows << %(#{INDENT}</div>)
            rows << %(</div>)
            rows.join("\n")
        end

        def find_lexer_with(language)
            downcase_language = language.try(:downcase)
            case downcase_language
            when "rb", "ruby"
                lexer = DiffRuby
            when "html"
                lexer = DiffHTML
            when "erb"
                lexer = DiffErb
            when "js", "javascript"
                lexer = DiffJS
            else
                lexer = Rouge::Lexer.find(downcase_language) || lexer = Rouge::Lexers::PlainText
            end
        end
    end

    class DiffRuby < Rouge::Lexers::Ruby
        prepend :root do
            rule(/^\+.*$\n?/, Generic::Inserted)
            rule(/^-+.*$\n?/, Generic::Deleted)
        end
    end

    class DiffHTML < Rouge::Lexers::HTML
        prepend :root do
            rule(/^\+.*$\n?/, Generic::Inserted)
            rule(/^-+.*$\n?/, Generic::Deleted)
        end
    end

    class DiffErb < Rouge::Lexers::ERB
        prepend :root do
            rule(/^\+.*$\n?/, Generic::Inserted)
            rule(/^-+.*$\n?/, Generic::Deleted)
        end
    end

    class DiffJS < Rouge::Lexers::Javascript
        prepend :root do
            rule(/^\+.*$\n?/, Generic::Inserted)
            rule(/^-+.*$\n?/, Generic::Deleted)
        end
    end

    class DiffCoffee < Rouge::Lexers::Coffeescript
        prepend :root do
            rule(/^\+.*$\n?/, Generic::Inserted)
            rule(/^-+.*$\n?/, Generic::Deleted)
        end
    end
    # markdown方法结束

end
