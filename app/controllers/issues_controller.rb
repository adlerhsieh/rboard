class IssuesController < ApplicationController
  def index
    repo_name = "mozo-wdg/mozo5"
    @client = Octokit::Client.new(access_token: ENV["github_token"])
    @issues = @client.issues(repo_name)

    @projects = @client.org_projects("mozo-wdg")
    @project = @projects.first
    @columns = @client.project_columns(@project.id)

    @columns.map! {|column|
      {
        name: column[:name],
        cards: @client.column_cards(column.id).map {|card|
          issue_number = card[:content_url].split("/").last
          @client.issue(repo_name, issue_number)
        }
      }
    }

  end
end
