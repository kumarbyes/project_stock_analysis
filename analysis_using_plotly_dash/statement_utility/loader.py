from abc import ABC, abstractmethod
import pandas as pd

class Loader(ABC):
    @abstractmethod
    def get_data(self):
        pass