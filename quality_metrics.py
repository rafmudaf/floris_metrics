# Copyright 2021 NREL

# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

# See https://floris.readthedocs.io for documentation


import copy
import numpy as np
import time
import warnings
import traceback
import logging

from floris.simulation import Floris
# from linux_perf import perf

WIND_DIRECTIONS = np.arange(0, 360.0, 5).tolist()
N_WIND_DIRECTIONS = len(WIND_DIRECTIONS)

WIND_SPEEDS = np.arange(8.0, 12.0, 0.2).tolist()
N_WIND_SPEEDS = len(WIND_SPEEDS)

N_TURBINES = 3
X_COORDS, Y_COORDS = np.meshgrid(
    5.0 * 126.0 * np.arange(0, N_TURBINES, 1),
    5.0 * 126.0 * np.arange(0, N_TURBINES, 1),
)
X_COORDS = X_COORDS.flatten().tolist()
Y_COORDS = Y_COORDS.flatten().tolist()

N_ITERATIONS = 20


def run_floris(input_dict):
    try:
        start = time.perf_counter()
        floris = Floris.from_dict(copy.deepcopy(input_dict.floris))
        if hasattr(floris, "initialize_domain"):
            floris.initialize_domain()
        floris.steady_state_atmospheric_condition()
        end = time.perf_counter()
        return end - start
    except KeyError as e:
        return -1.0
    except Exception as e:
        logging.error(traceback.format_exc())
        return -1.0


def time_profile(input_dict):

    # Run once to initialize Python and memory
    run_floris(input_dict)

    times = np.zeros(N_ITERATIONS)
    for i in range(N_ITERATIONS):
        times[i] = run_floris(input_dict)

    return np.sum(times) / N_ITERATIONS


def test_time_jensen_jimenez(sample_inputs_fixture):
    sample_inputs_fixture.floris["wake"]["model_strings"]["velocity_model"] = "jensen"
    sample_inputs_fixture.floris["wake"]["model_strings"]["deflection_model"] = "jimenez"
    return time_profile(sample_inputs_fixture)


def test_time_gauss(sample_inputs_fixture):
    sample_inputs_fixture.floris["wake"]["model_strings"]["velocity_model"] = "gauss"
    sample_inputs_fixture.floris["wake"]["model_strings"]["deflection_model"] = "gauss"
    return time_profile(sample_inputs_fixture)


def test_time_gch(sample_inputs_fixture):
    sample_inputs_fixture.floris["wake"]["model_strings"]["velocity_model"] = "gauss"
    sample_inputs_fixture.floris["wake"]["model_strings"]["deflection_model"] = "gauss"
    sample_inputs_fixture.floris["wake"]["enable_transverse_velocities"] = True
    sample_inputs_fixture.floris["wake"]["enable_secondary_steering"] = True
    sample_inputs_fixture.floris["wake"]["enable_yaw_added_recovery"] = True
    return time_profile(sample_inputs_fixture)


def test_time_cumulative(sample_inputs_fixture):
    sample_inputs_fixture.floris["wake"]["model_strings"]["velocity_model"] = "cc"
    sample_inputs_fixture.floris["wake"]["model_strings"]["deflection_model"] = "gauss"
    return time_profile(sample_inputs_fixture)


def test_time_empiricalgauss(sample_inputs_fixture):
    sample_inputs_fixture.floris["wake"]["model_strings"]["turbulence_model"] = "wake_induced_mixing"
    sample_inputs_fixture.floris["wake"]["model_strings"]["velocity_model"] = "empirical_gauss"
    sample_inputs_fixture.floris["wake"]["model_strings"]["deflection_model"] = "empirical_gauss"
    sample_inputs_fixture.floris["wake"]["enable_transverse_velocities"] = False
    sample_inputs_fixture.floris["wake"]["enable_secondary_steering"] = False
    sample_inputs_fixture.floris["wake"]["enable_yaw_added_recovery"] = True
    return time_profile(sample_inputs_fixture)


# def memory_profile(input_dict):
#     # Run once to initialize Python and memory
#     floris = Floris.from_dict(copy.deepcopy(input_dict.floris))
#     floris.steady_state_atmospheric_condition()

#     with perf():
#         for i in range(N_ITERATIONS):
#             floris = Floris.from_dict(copy.deepcopy(input_dict.floris))
#             floris.steady_state_atmospheric_condition()

#     print("Size of one data array:", 64 * N_WIND_DIRECTIONS * N_WIND_SPEEDS * N_TURBINES * 25 / (1000 * 1000), "MB")


# def test_mem_jensen_jimenez(sample_inputs_fixture):
#     sample_inputs_fixture.floris["wake"]["model_strings"]["velocity_model"] = "jensen"
#     sample_inputs_fixture.floris["wake"]["model_strings"]["deflection_model"] = "jimenez"
#     memory_profile(sample_inputs_fixture)
    

if __name__=="__main__":
    warnings.filterwarnings('ignore')

    import sys
    from conftest import SampleInputs

    commit_hash = sys.argv[1]

    sample_inputs = SampleInputs()
    sample_inputs.floris["solver"]["turbine_grid_points"] = 5
    sample_inputs.floris["farm"]["layout_x"] = X_COORDS
    sample_inputs.floris["farm"]["layout_y"] = Y_COORDS
    # sample_inputs.floris["farm"]["turbine_type"] = len(X_COORDS) * ["nrel_5mw"]

    sample_inputs.floris["flow_field"]["wind_directions"] = WIND_DIRECTIONS
    sample_inputs.floris["flow_field"]["wind_speeds"] = WIND_SPEEDS

    # print()
    # print("### Memory profiling")
    # test_mem_jensen_jimenez(sample_inputs)

    # print()
    # print("### Performance profiling")
    time_jensen = test_time_jensen_jimenez(sample_inputs)
    time_gauss = test_time_gauss(sample_inputs)
    time_gch = test_time_gch(sample_inputs)
    time_cc = test_time_cumulative(sample_inputs)
    time_emg = test_time_empiricalgauss(sample_inputs)

    # print("{:.4f}, {:.4f}, {:.4f}, {:.4f}, {:.4f},".format(time_jensen, time_gauss, time_gch, time_cc, time_emg))
    print(
        f"(\"{commit_hash}\", \"{commit_hash[0:8]}\", datetime( ), "
        f"{time_jensen:.4f}, {time_gauss:.4f}, {time_gch:.4f}, {time_cc:.4f}, {time_emg:.4f}, "
        f"0.0000, \"{commit_hash[0:8]}\"),"
    )
