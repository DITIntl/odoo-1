# coding: utf-8

from openerp import api, fields, models


class CustomSaleOrder(models.Model):
    _inherit = 'sale.order'

    model_external = fields.Char(
        help='The model name of the object that originates this element')
    id_external = fields.Integer(help='ID of the model source object')

    @api.model
    def get_external_object(self):
        """Returns the Record related to the external model object.
        For example, the account.invoice object associated to the report."""
        model_obj = None
        if self.model_external and self.id_external:
            model_obj = self.env[self.model_external].browse(self.id_external)
            # model_obj = self.pool.get(self.model_external).browse(
            #     self.cr, self.uid, self.id_external
            # )
        return model_obj

    @api.model
    def get_human_value(self, field_name, selection_option):
        """Convert technical key to value to show in selection human readable
        for the user.
        :param field_name: selection field name
        :param selection_option: the technical value of actual_state
        :return: string with the value that will be shown in the user
        """
        data = dict(self.fields_get().get(field_name).get('selection'))
        return data.get(selection_option, '')
