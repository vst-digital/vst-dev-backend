class ProjectUserMemoSerializer
  include JSONAPI::Serializer
  has_many :project_user_memo_replies
  attributes :project_user_memo_replies
  attributes :id, :subject, :receiver_id, :sender_id, :cc, :bcc, :created_at, :body, :answers, :content, :read, :receiver, :sender
end