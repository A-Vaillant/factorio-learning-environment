import pytest

from game_types import Prototype

@pytest.fixture()
def game(instance):
    instance.reset()
    yield instance.namespace

def test_get_score(game):
    score, _ = game.score()
    assert score
