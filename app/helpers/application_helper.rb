module ApplicationHelper
  
  def page_title(t=nil)
    return (@page_title.try(:html_safe)) || ENV["SITE_NAME"] if t.nil?
    @page_title = (@page_title.nil? ? t : @page_title + ' &mdash; '.html_safe + t).html_safe
  end

  def flashes
    marks = { notice: "* ", error: "✗ ", success: "✓ ", alert: '✦ ', info: '✦ '}
    ActiveSupport::SafeBuffer.new.tap do |flash_list|
      [:alert, :notice, :error, :success, :info].each do |category|
        flash.now[category] ||= []
        flash.now[category] = [flash.now[category]] if flash.now[category].is_a? String
        flash.now[category].each do |message|
          flash_list << content_tag(:div, {class: "alert alert-#{category}"}) do
            marks[category] + message.html_safe
          end
        end
      end
    end
  end

  def pre_yield
    page_title("Daily Temperature Pledge")
    %Q(<!DOCTYPE html><html><head><title>) + page_title + %Q(</title>
    <meta content='width=device-width, initial-scale=1' name='viewport'>
    <meta content='Submit your temperature and join the most important crowd sourcing operation in US history.' name='description'>
    <meta content='covid, temperature, fever, data, open data, data source, reporting, medical, coronavirus' name='keywords'>
    <meta content='en' name='language'>
    <meta content='index, follow' name='robots'>) + stylesheet_link_tag('application', media: 'all') + %Q(<body>
    <div class='mt1 flex flex-center' id='vcenter' style='min-height:95vh'>
    <div class='flex-auto'><main class='container'>).html_safe
  end

  def post_yield
    %Q(</main><script async defer src="https://cdn.simpleanalytics.io/hello.js"></script>
    <noscript><img src="https://api.simpleanalytics.io/hello.gif" alt=""></noscript></body></html>).html_safe
  end

  def form_group(options={}, &block)
    inner = capture(&block)
    ("<div class='group #{options[:class]}'><div class='clearfix'>" + inner + '</div></div>').html_safe
  end
  
end
