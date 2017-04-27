class IssuesController < ApplicationController
  def index
    @client = Octokit::Client.new(access_token: ENV["github_token"])
    @issues = @client.issues("#{ENV["org_name"]}/#{ENV["repo_name"]}", state: "all")

    @projects = @client.org_projects(ENV["org_name"])
    @project = @projects.first
    @columns = @client.project_columns(@project.id)

    @columns.map! {|column|
      {
        name: column[:name],
        cards: @client.column_cards(column.id).map {|card|
          issue_number = card[:content_url].split("/").last.to_i
          @issues.select {|issue| issue[:number] == issue_number }.first
          # @client.issue(repo_name, issue_number)
        }.compact
      }
    }

  end
end
