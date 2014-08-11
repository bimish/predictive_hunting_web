module Exceptions
  class NotAuthorized < StandardError; end
  class InvalidState < StandardError; end
  class MustBeOverridden < StandardError; end
end
