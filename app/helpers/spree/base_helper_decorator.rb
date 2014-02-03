Spree::BaseHelper.class_eval do
  
  def taxons_tree(root_taxon, current_taxon, max_level = 1)
    logger.debug "************ taxon_tree root = " + root_taxon.name + "max_level = " + max_level.to_s
    return '' if max_level < 1 || root_taxon.children.empty?
    content_tag :ul, :class => 'taxons-list' do
      root_taxon.children.map do |taxon|
        css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'current' : nil
        content_tag :li, :class => css_class do
          link_to(taxon.name, seo_url(taxon)) +
          taxons_tree(taxon, current_taxon, max_level - 1)
        end
      end.join("\n").html_safe
    end
  end

  def get_category_root
    (current_store.present? ? 
      Spree::Taxonomy.where(["store_id = ? and name = 'Categories'", current_store.id]).includes(:root => :children): 
      Spree::Taxonomy.where(:name => 'Categories').includes(:root => :children)).first.root
  end

  def categories_tree(root_taxon, current_taxon, max_level, current_level = 1, isdropdown = false)
    return '' if max_level < current_level || root_taxon == nil || root_taxon.children.empty?
    css_class = current_level == 1 ? 'nav pull-left' : ''
    css_class += isdropdown ? 'dropdown-menu' : ''
    content_tag :ul, :class => css_class do
      # root_taxon.children.sort! { |a,b| a.position <=> b.position }
      root_taxon.children.map do |taxon|
        css_class = taxon.children.empty? ? nil : 'dropdown'
        content_tag :li, :class => css_class do
          if css_class == 'dropdown'
            link_to(raw(taxon.name+content_tag("strong", "", :class=>"caret")), '#', :class => 'dropdown-toggle', 'data-toggle' => 'dropdown') +
            categories_tree(taxon, current_taxon, max_level, current_level + 1, current_level == 1)
          else
            link_to(taxon.name, seo_url(taxon))  +
            categories_tree(taxon, current_taxon, max_level, current_level + 1)
          end
        end
      end.join("\n").html_safe
    end
  end

  def link_to_clone(resource, options={})
    options[:data] = {:action => 'clone'}
    link_to_with_icon('icon-copy', Spree.t(:clone), clone_admin_product_url(resource), options)
  end

  def link_to_new(resource)
    options[:data] = {:action => 'new'}
    link_to_with_icon('icon-plus', Spree.t(:new), edit_object_url(resource))
  end

  def link_to_edit(resource, options={})
    options[:data] = {:action => 'edit'}
    link_to_with_icon('icon-edit', Spree.t(:edit), edit_object_url(resource), options)
  end

  def link_to_edit_url(url, options={})
    options[:data] = {:action => 'edit'}
    link_to_with_icon('icon-edit', Spree.t(:edit), url, options)
  end

  def link_to_delete(resource, options={})
    url = options[:url] || object_url(resource)
    name = options[:name] || Spree.t(:delete)
    options[:class] = "delete-resource"
    options[:data] = { :confirm => Spree.t(:are_you_sure), :action => 'remove' }
    link_to_with_icon 'icon-trash', name, url, options
  end

  def link_to_with_icon(icon_name, text, url, options = {})
    options[:title] = text if options[:no_text]
    icon = raw("<i class='#{icon_name}'></i> ")
    text = icon + (options[:no_text] ? '' : raw("<span class='text'>#{text}</span>"))
    options.delete(:no_text)
    link_to(text, url, options)
  end

  def icon(icon_name)
    icon_name ? content_tag(:i, '', :class => icon_name) : ''
  end

  def button(text, icon_name = nil, button_type = 'submit', options={})
    button_tag(text, options.merge(:type => button_type, :class => "#{icon_name} button"))
  end

  def button_link_to(text, url, html_options = {})
    if (html_options[:method] &&
    html_options[:method].to_s.downcase != 'get' &&
    !html_options[:remote])
      form_tag(url, :method => html_options.delete(:method)) do
        button(text, html_options.delete(:icon), nil, html_options)
      end
    else
      if html_options['data-update'].nil? && html_options[:remote]
        object_name, action = url.split('/')[-2..-1]
        html_options['data-update'] = [action, object_name.singularize].join('_')
      end

      html_options.delete('data-update') unless html_options['data-update']

      html_options[:class] = 'button'

      if html_options[:icon]
        html_options[:class] += " #{html_options[:icon]}"
      end
      link_to(text_for_button_link(text, html_options), url, html_options)
    end
  end

  def text_for_button_link(text, html_options)
    s = ''
    s << text
    raw(s)
  end

  def full_address(address)
    full_address = address.address2 == nil ? address.address1 : address.address1 + ', ' + address.address2
    full_address += ', ' + address.city + ', ' + address.state_text + ', ' + address.zipcode

    full_address
  end

  def button(text, icon_name = nil, button_type = 'submit', options={})
    button_tag(content_tag('span', icon(icon_name) + ' ' + text), options.merge(:type => button_type))
  end

  def icon(icon_name)
    icon_name ? image_tag("admin/icons/#{icon_name}.png") : ''
  end

  def link_to_add_fields(name, target)
    link_to icon('add') + name, 'javascript:', :data => { :target => target }, :class => "add_fields"
  end

  def breadcrumbs(taxon = nil, product = nil, sep = "&nbsp;&raquo;&nbsp;")
    if String === product
      sep = product
      product = nil
    end

    return "" unless taxon || product || current_page?(products_path)

    session['last_crumb'] = taxon ? taxon.permalink : nil
    sep = raw(sep)
    crumbs = [content_tag(:li, link_to(t(:home) , root_path) + sep)]

    if taxon
      crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, link_to(ancestor.name , seo_url(ancestor)) + sep) } unless taxon.ancestors.empty?
      if product
        crumbs << content_tag(:li, link_to(taxon.name , seo_url(taxon)) + sep)
        crumbs << content_tag(:li, content_tag(:span, product.name))
      else
        crumbs << content_tag(:li, content_tag(:span, taxon.name))
      end
    elsif product
      crumbs << content_tag(:li, link_to(t('products') , products_path) + sep)
      crumbs << content_tag(:li, content_tag(:span, product.name))
    else
      crumbs << content_tag(:li, content_tag(:span, t('products')))
    end
    crumb_list = content_tag(:ul, raw(crumbs.flatten.map{|li| li.mb_chars}.join), :class => 'breadcrumb')
    content_tag(:div, crumb_list, :id => 'breadcrumbs')
  end

  def last_crumb_path
    plink = session['last_crumb']
    if plink && taxon = Spree::Taxon.find_by_permalink(plink)
      seo_url(taxon)
    else
      products_path
    end
  end

  def mobile_logo(image_path=Spree::Config[:logo])
    link_to image_tag(image_path, :size => '54x20'), root_path
  end

end