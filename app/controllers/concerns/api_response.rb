module ApiResponse
  def json_response(object, status = :ok, serializer = nil, options = {})
    render json: serialized_response(object, serializer, options), status: status
  end

  def serialized_response(obj, serializer, options)
    if serializer.present?
      included_array = included_assoc(options[:include])
      serializer.new(
        obj,
        options.merge({
          include: included_array,
          params: { include: included_array }
        })
      ).serializable_hash
    else
      obj
    end
  end

  def included_assoc(default_include = [])
    include_array = include_params || []
    include_array.push(default_include).flatten.uniq
  end

  def render_json data
    render json: { data: data }, status: :ok
  end

  def include_params
    params[:include].is_a?(Array) ? params[:include] : params[:include].try(:split,',')
  end

  def generate_pagination(paginated_obj)
    per_page_value = 10
    return {} unless paginated_obj.respond_to?(:current_page)

    {
      meta: {
        pagination: {
          current_page: paginated_obj.current_page,
          prev_page: paginated_obj.prev_page,
          next_page: paginated_obj.next_page,
          total_pages: paginated_obj.total_pages,
          per_page: per_page_value,
          count: paginated_obj.total_count
        }
      }
    }
  end
  
end
