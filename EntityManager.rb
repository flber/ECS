class EntityManager
  attr_reader :entity_list

  def initialize
    @entity_list = Hash.new
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
    @entity_list.merge({id => Array.new})
  end

  def remove_entity(tag)
    id = @id_at_tag[tag]
    @entity_list.delete(id)
    @id_at_tag.delete(tag)
    @tag_at_id.delete(id)
  end

  def add_component(tag, component)
    id = @id_at_tag[tag]
    if @entity_list[id].nil?
      @entity_list[id] = Array.new(1){component}
    else
      @entity_list[id] << component
    end
  end

  def components_of(id)
    components = []
    @entity_list[id].each do |comp|
      components << comp.class
    end
    return components
  end

  def has_component_of_type(id, component_class)
    return components_of(id).include?(component_class)
  end

  def get_component(id, component_class)
    @entity_list[id].each do |comp|
      if comp.to_s == component_class.to_s
        return comp
      end
    end
    return nil
  end

  def get_component_with_tag(tag, component_class)
    id = @id_at_tag[tag]
    @entity_list[id].each do |comp|
      if comp.to_s == component_class.to_s
        return comp
      end
    end
    return nil
  end

  def entities_with_component(component_class)
    entities = []
    @entity_list.each do |e|
      entity = @entity_list[e[0]]
      entity.each do |c|
        if c.to_s == component_class.to_s
          entities << e[0]
        end
      end
    end
    return entities
  end

  #temp_ent_list should be passed as @entity_list
  def entities_with_components(component_classes)
    temp_entities = @entity_list
    temp_entities.each do |e|
      component_classes.each do |c|
        comps = []
        e[1].each do |comp_ob|
          comps << comp_ob.to_s
        end
        if !comps.include?(c.to_s)
          temp_entities.delete(e)
        end
      end
    end
    id_list = []
    temp_entities.each do |e|
      id_list << e[0]
    end
    return id_list
  end

  # not entirely sure if this works...
  # def add_entity(tag, entity)
  #   id = @id_at_tag[tag]
  #   @entity_list[id] << {entity => @entity_list[entity]
  # end

end
