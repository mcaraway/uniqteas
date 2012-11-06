Spree::BaseHelper.class_eval do
  def full_address(address)
    full_address = address.address2 == nil ? address.address1 : address.address1 + ', ' + address.address2
    full_address += ', ' + address.city + ', ' + address.state_text + ', ' + address.zipcode

    full_address
  end

  def small_image(product, options={})
    if product.images.empty?
      image_tag "/assets/TeaTinWithLabel.png", :size => "182x190", :alt => product.name
    else
      image_tag product.images.first.attachment.url(:small), options
    end
  end

  def xmini_tea_tin_image (product)
    if product.images.empty?
      image_tag "/assets/CustomTeaLabel.png", :size => "60x136", :alt => product.name
    else
      image_tag product.images.first.attachment.url(:original), :size => "60x136", :alt => product.name
    end
  end

  def mini_tea_tin_image (product)
    if product.images.empty?
      image_tag "/assets/CustomTeaLabel.png", :size => "82x186", :alt => product.name
    else
      image_tag product.images.first.attachment.url(:original), :size => "82x186", :alt => product.name
    end
  end

  def small_tea_tin_image (product)
    if product.images.empty?
      image_tag "/assets/CustomTeaLabel.png", :size => "140x186", :alt => product.name
    else
      image_tag product.images.first.attachment.url(:original), :size => "140x186", :alt => product.name
    end
  end

  def small_tea_tag_image (product)
    if product.images[1] == nil
      image_tag "/assets/TeaTagLabel.png", :size => "50x42"
    else
      image_tag product.images[1].attachment.url(:small), :size => "50x42"
    end
  end

  def xmini_tea_tag_image (product)
    if product.images[1] == nil
      image_tag "/assets/TeaTagLabel.png", :size => "37x31"
    else
      image_tag product.images[1].attachment.url(:small), :size => "37x31"
    end
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
    logger.debug "****** entered bradcrumbs taxon = #{taxon}"
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
    crumb_list = content_tag(:ul, raw(crumbs.flatten.map{|li| li.mb_chars}.join), :class => 'inline')
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
end