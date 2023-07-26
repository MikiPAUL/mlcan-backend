class CommentSerializer < ActiveModel::Serializer
    attributes :id, :body, :container_id, :created_date
    belongs_to :user, serializer: UserCommentSerializer

    def created_date
        object.created_at.to_date
    end
end