class EntityManager

  def initialize
    @placed_entity_list = Hash.new
    @preset_entity_list = Hash.new
    @ids_to_tags = Hash.new
    @tags_to_ids = Hash.new
  end

  def create_id
    return SecureRandom.uuid
  end

  def create_entity(tag)
    id = create_id
    ids_to_tags[id] = tag
    tags_to_ids[tag] = id
    @placed_entity_list[id] = Array.new
  end

  def remove_entity(tag)
    id = ids_to_tags[tag]
    @placed_entity_list.delete(id)
  end

  def add_component(tag, component)
    id = ids_to_tags[tag]
    @placed_entity_list[id] << component
  end

  def add_entity(tag, entity)
    id = ids_to_tags[tag]
    @placed_entity_list[id] << entity
  end

  def components_of_entity(tag)
    id = ids_to_tags[tag]
    return @placed_entity_list[id]
  end

  def entities_with_component(component)
    entities = Array.new
    @placed_entity_list.each do |e|
      if e.include? component
        entities << e
      end
    end
    return entities
  end

end
