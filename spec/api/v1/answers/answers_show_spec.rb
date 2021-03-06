require 'rails_helper'

describe 'Answers API SHOW', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :full_pack, count_relations: 2) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it_behaves_like 'API return Pub Fields' do
        let(:fields) { %w[id body best author_id created_at updated_at] }
        let(:resource) { answer }
      end

      describe 'links' do
        let(:link) { answer.links.first }
        let(:link_response) { answer_response['links'].last }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq 2
        end

        it_behaves_like 'API return Pub Fields' do
          let(:fields) { %w[name url] }
          let(:resource) { link }
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }
        let(:file_response) { answer_response['files'].last }

        it 'returns urls of files' do
          expect(answer_response['files'].size).to eq 1
        end

        it 'returns url file' do
          expect(file_response).to eq rails_blob_path(file, only_path: true)
        end
      end

      describe 'comments' do
        let(:comment) { answer.comments.first }
        let(:comment_response) { answer_response['comments'].last }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 2
        end

        it_behaves_like 'API return Pub Fields' do
          let(:fields) { %w[id body created_at updated_at] }
          let(:resource) { comment }
        end
      end

    end
  end

end
