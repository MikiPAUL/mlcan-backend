module PaginationConcern extend ActiveSupport::Concern 
    def pagination_meta(object)
        {
            current_page: object.current_page,
            next_page: object.next_page,
            previous_page: object.prev_page,
            total_pages: object.total_pages,
            total_count: object.total_count
        }
    end
end