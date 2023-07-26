require 'rails_helper'

RSpec.describe "API::V1:Repair_lists", type: :request do

    describe 'get repair_lists with latest version' do

        let!(:user) { create(:user) }
        let!(:token) { authorization user }
        let!(:repair_lists)  { [ 
            create(:repair_list, repair_number: 1, version: 1),
            create(:repair_list, repair_number: 1, version: 2),
            create(:repair_list, repair_number: 2, version: 1),
            create(:repair_list, repair_number: 3, version: 4),
            create(:repair_list, repair_number: 4, version: 5),
            create(:repair_list, repair_number: 1, version: 10),
        ]}

        it 'returns recently updated repair_lists below the version v' do
            get '/api/repair_lists?version=2', headers: { Authorization: token }, as: :json
            
            res_data = JSON.parse(response.body)["repair_lists"]
            
            expect(res_data.length).to eq(2)
            expect(res_data[0]['repair_number']).to eq(repair_lists.pluck(:repair_number)[1])
            expect(res_data[1]['repair_number']).to eq(repair_lists.pluck(:repair_number)[2])
        end
    end

    describe 'post /api/repair_lists' do
        
        let!(:user) { create(:user) }
        let!(:token) { authorization user }
        let!(:repair_lists_params) { 
            {
                "repair_details": {
                    "repair_number": "840",
                    "container_repair_area": "Optimization",
                    "container_damaged_area": "Chief",
                    "repair_type": "non_maersk"
                },
                "non_maersk_details": {
                    "cost_details": {
                        "hours": "429",
                        "material_cost": "539.68"
                    },
                    "customer_related_details": {
                        "container_section": "Brand",
                        "damaged_area": "Creative",
                        "repair_type": "(Keeling)",
                        "description": "e-services",
                        "condition": {
                            "comp": 774,
                            "dam": "315",
                            "rep": "324"
                        },
                        "component": "Identity",
                        "event": "Oregon",
                        "location": "Factors",
                        "id_source": "scalable",
                        "area": "Mobility",
                        "area2": "Accountability"
                    }
                },
                "merc_details": {
                    "cost_details": {
                        "max_min_cost": 92.41,
                        "unit_max_cost": 581.86,
                        "hours_per_cost": 349.08,
                        "max_pieces": 779,
                        "units": 592
                    },
                    "customer_related_details": {
                        "repair_mode": "Burundi",
                        "mode_number": "Personal",
                        "repair_code": "444",
                        "combined": "optical",
                        "description": "Engineer",
                        "id_source": "68"
                    }
                }
            }
        }

        it 'return 201 - created repair_lists successfully' do
            post '/api/repair_lists',  headers: { Authorization: token }, as: :json, params: repair_lists_params

            expect(response.status).to be(201)
        end 
    end

    describe 'put /api/repair_lists' do

        let!(:user) { create(:user) }
        let!(:token) { authorization user }    
        let!(:repair_list) { create(:repair_list) }
        let!(:update_params) { 
            {
                "repair_details": {
                    "repair_number": "840",
                    "container_repair_area": "Optimization",
                    "container_damaged_area": "Chief",
                    "repair_type": "non_maersk"
                },
                "non_maersk_details": {
                    "cost_details": {
                        "hours": "429",
                        "material_cost": "539.68"
                    },
                    "customer_related_details": {
                        "container_section": "Brand",
                        "damaged_area": "Creative",
                        "repair_type": "(Keeling)",
                        "description": "e-services",
                        "condition": {
                            "comp": 774,
                            "dam": "315",
                            "rep": "324"
                        },
                        "component": "Identity",
                        "event": "Oregon",
                        "location": "Factors",
                        "id_source": "scalable",
                        "area": "Mobility",
                        "area2": "Accountability"
                    }
                },
                "merc_details": {
                    "cost_details": {
                        "max_min_cost": 92.41,
                        "unit_max_cost": 581.86,
                        "hours_per_cost": 349.08,
                        "max_pieces": 779,
                        "units": 592
                    },
                    "customer_related_details": {
                        "repair_mode": "Burundi",
                        "mode_number": "Personal",
                        "repair_code": "444",
                        "combined": "optical",
                        "description": "Engineer",
                        "id_source": "68"
                    }
                }
            }
        }

        it 'returns 200 - updated repair_lists successfully' do
            
        end
    end
end