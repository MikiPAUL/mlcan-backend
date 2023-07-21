class CommentSerializer < ActiveModel::Serializer
    attributes :id, :body, :container_id
    has_one :user, serializer: UserCommentSerializer
end