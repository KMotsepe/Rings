module ApplicationHelper
    
    def display_title(page_title=" ")
        base_title = "Car Rental App"
        if page_title.nil?
            base_title
        else
            page_title
        end
    end
    
end
