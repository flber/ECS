class EntityManager
  attr_reader :component_stores

  def initialize
    @component_stores = Hash.new
    # a list of ids indexed by tag
    @id_at_tag = Hash.new
    # a list of tags indexed by id
    @tag_at_id = Hash.new
    #an array of used ids
    @used_ids = Array.new
  end

  def get_id_at_tag
    return @id_at_tag
  end

  def get_tag_at_id
    return @tag_at_id
  end

  def create_id
    id = rand(1..10000)
    while @used_ids.include?(id)
      id = rand(1..1000000)
    end
    @used_ids << id
    return id
  end

  def create_entity(tag)
    id = create_id
    @id_at_tag[tag] = id
    @tag_at_id[id] = tag
    @component_stores.merge({id => Array.new})
  end

  def remove_entity(tag)
    id = @id_at_tag[tag]
    @component_stores.delete(id)
    @id_at_tag.delete(tag)
    @tag_at_id.delete(id)
  end

  def add_component(tag, component)
    id = @id_at_tag[tag]
    if @component_stores[id].nil?
      @component_stores[id] = Array.new(1){component}
    else
      @component_stores[id] << component
    end
  end

  def components_of(tag)
    id = @id_at_tag[tag]
    components = []
    @component_stores[id].each do |comp|
      components << comp.class
    end
    return components
  end

  def has_component_of_type(tag, component_class)
    return components_of(tag).include?(component_class)
  end

  def get_component(id, component_class)
    @component_stores[id].each do |comp|
      if comp.to_s == component_class.to_s
        return comp
      end
    end
    return nil
  end

  def entities_with_component(component_class)
    entities = []
    @component_stores.each do |e|
      entity = @component_stores[e[0]]
      entity.each do |c|
        if c.to_s == component_class.to_s
          entities << e[0]
        end
      end
    end
    return entities
  end

  # not entirely sure if this works...
  # def add_entity(tag, entity)
  #   id = @id_at_tag[tag]
  #   @component_stores[id] << {entity => @component_stores[entity]
  # end

end
