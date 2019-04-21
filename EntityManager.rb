class EntityManager
  attr_reader :entity_list

  def initialize
    @entity_list = Hash.new
    @ids_to_tags = Hash.new
    @tags_to_ids = Hash.new
  end

  def create_id
    return rand(1..10000)
  end

  def create_entity(tag)
    id = create_id
    @ids_to_tags[id] = tag
    @tags_to_ids[tag] = id
    @entity_list[id] = Hash.new
  end

  def remove_entity(tag)
    id = @ids_to_tags[tag]
    @entity_list.delete(id)
  end

  def add_component(tag, component)
    id = @ids_to_tags[tag]
    if @entity_list[id] == nil
      @entity_list[id] = Hash.new
      @entity_list[id].store(component.to_s, component)
      puts "added #{component} to #{@tags_to_ids[tag]}"
    else
      @entity_list[id].store(component.to_s, component)
      puts "added #{component} to #{@tags_to_ids[tag]}"
    end
  end

  # not entirely sure if this works...
  # def add_entity(tag, entity)
  #   id = @ids_to_tags[tag]
  #   @entity_list[id] << {entity => @entity_list[entity]
  # end

  def components_of_entity(tag)
    id = @ids_to_tags[tag]
    return @entity_list[id]
  end

  def entities_with_component(component)
    entities = Array.new
    @entity_list.each do |e|
      if e.include? component
        entities << e
      end
    end
    return entities
  end

  def get_component(tag, component)
    id = @ids_to_tags[tag]
    return @entity_list[id][component.to_s]
  end

end
